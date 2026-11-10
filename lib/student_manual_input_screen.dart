import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Student_Academic.dart';

class StudentManualInputScreen extends StatefulWidget {
  const StudentManualInputScreen({super.key});

  @override
  State<StudentManualInputScreen> createState() => _StudentManualInputScreenState();
}

class _StudentManualInputScreenState extends State<StudentManualInputScreen> {
  final _formKey = GlobalKey<FormState>();

  // متحكمات جلب مدخلات الطالب
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  
  String? _selectedDepartment;

  // قائمة الأقسام المتاحة مطابقة تماماً للقاعدة
  static const List<String> _departments = [
    'علوم الحاسب',
    'هندسة البرمجيات',
    'الأمن السيبراني',
    'تقنية المعلومات',
    'شبكات الحاسب',
    'هندسة الشبكات',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  // دالة جلب معرف الجهاز الفريد والحقيقي للمستخدم
  Future<String> _getUniqueDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = 'unknown_device';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // معرف فريد لجهاز الأندرويد
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown_ios';
      }
    } catch (e) {
      deviceId = 'error_device_id';
    }
    return deviceId;
  }

  // دالة الإرسال والتحقق من مطابقة البيانات وربط الجهاز
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
      );

      try {
        // جلب معرف الجهاز الفريد آلياً
        String deviceId = await _getUniqueDeviceId();

        // رابط السيرفر (تأكد من تغييره إلى 10.0.2.2 لمحاكي أندرويد أو آي بي حقيقي)
        final url = Uri.parse('http://127.0.0.1:8000/api/student/register/');

        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'student_id': _studentIdController.text.trim(),
            'full_name': _nameController.text.trim(),
            'department': _selectedDepartment,
            'device_id': deviceId, // إرسال معرف الجهاز الفعلي للسيرفر
          }),
        );

        if (!mounted) return;
        Navigator.pop(context); // إغلاق نافذة التحميل

        // التحقق من الاستجابة الناجحة
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          
          // حفظ حالة تسجيل الدخول محلياً لكي لا يضطر الطالب لإعادة إدخالها
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('studentId', _studentIdController.text.trim());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'تم التحقق وتأكيد البيانات بنجاح!'),
              backgroundColor: const Color(0xFFD4AF37),
              duration: const Duration(seconds: 2),
            ),
          );

          // التوجيه المباشر إلى لوحة التحكم
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentHomeDashboard(),
            ),
          );
        } else {
          // إذا رفض السيرفر (مثل محاولة الدخول من جهاز آخر أو خطأ في البيانات)
          final errorData = jsonDecode(response.body);
          _showErrorDialog(
            errorData['error'] ?? 'البيانات المدخلة غير متطابقة أو الحساب مرتبط بهاتف آخر.',
          );
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // إغلاق نافذة التحميل عند حدوث استثناء
        _showErrorDialog(
          'تعذر الاتصال بالسيرفر. تأكد من تشغيل سيرفر Django وبأن الرابط صحيح.',
        );
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F003A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('خطأ في التحقق', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إعادة المحاولة', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A004E),
      appBar: AppBar(
        title: const Text(
          'تسجيل بيانات الطالب',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1F003A),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: 20),
                Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 70,
                  color: Color(0xFFD4AF37),
                ),
                SizedBox(height: 16),
                Text(
                  'أدخل بياناتك الأكاديمية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'سيتم ربط حسابك بمعرّف جهازك الفريد آلياً لضمان الأمان',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                SizedBox(height: 32),
                _StudentFormFieldsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentFormFieldsSection extends StatelessWidget {
  const _StudentFormFieldsSection();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_StudentManualInputScreenState>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // حقل الاسم الرباعي
        TextFormField(
          controller: state._nameController,
          style: const TextStyle(color: Colors.white),
          decoration: _buildInputDecoration('الاسم الرباعي', Icons.person_outline),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال الاسم الرباعي';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // حقل الرقم الأكاديمي
        TextFormField(
          controller: state._studentIdController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: _buildInputDecoration('الرقم الأكاديمي', Icons.badge_outlined),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال الرقم الأكاديمي';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // القائمة المنسدلة للقسم
        DropdownButtonFormField<String>(
          value: state._selectedDepartment,
          dropdownColor: const Color(0xFF1F003A),
          style: const TextStyle(color: Colors.white),
          decoration: _buildInputDecoration('القسم الدراسي', Icons.school_outlined),
          items: _StudentManualInputScreenState._departments.map((dept) {
            return DropdownMenuItem(
              value: dept,
              child: Text(dept, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (val) => state.setState(() => state._selectedDepartment = val),
          validator: (val) => val == null ? 'يرجى اختيار القسم الدراسي' : null,
        ),
        const SizedBox(height: 40),

        // زر التأكيد والارسال
        ElevatedButton(
          onPressed: state._submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: const Color(0xFF2A004E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          child: const Text(
            'تأكيد وحفظ البيانات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFD4AF37)),
      prefixIcon: Icon(icon, color: Color(0xFFD4AF37)),
      filled: true,
      fillColor: const Color(0xFF1F003A),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}