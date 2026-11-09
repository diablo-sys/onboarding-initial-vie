import 'package:flutter/material.dart';

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

  // قائمة الأقسام المتاحة (ثابتة لتحسين الأداء)
  static const List<String> _departments = [
    'علوم الحاسب (CS)',
    'هندسة البرمجيات (SE)',
    'الأمن السيبراني (Cybersecurity)',
    'تقنية المعلومات (IT)',
    'شبكات الحاسب (Networking)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // هنا يتم تجهيز البيانات للربط مع FastAPI لاحقاً
      final studentData = {
        'action': 'student_login',
        'full_name': _nameController.text.trim(),
        'student_id': _studentIdController.text.trim(),
        'department': _selectedDepartment,
      };

      debugPrint("Student Data Prepared: $studentData");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جاري جلب معرف الجهاز والتحقق من البيانات...'),
          backgroundColor: Color(0xFFD4AF37),
        ),
      );

      // TODO: التوجه إلى لوحة تحكم الطالب الرئيسية بعد التوثيق
    }
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

                // بقية محتوى الحقول مدعوم داخل حقول النموذج
                _StudentFormFieldsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// تم فصل حقول النموذج في StatelessWidget مستقل ومُحسّن بـ const لتحسين إعادة البناء (Rebuild Optimization)
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
      prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
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