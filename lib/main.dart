import 'dart:convert';
import 'package:flutter/material.dart';

/// 1. هويّة الألوان والتنسيق البصري (AppColors)
class AppColors {
  // الألوان الرئيسية
  static const Color primaryPurple = Color(0xFF2A004E); // بنفسجي ملكي عميق
  static const Color secondaryPurple = Color(0xFF3B1E54); // بنفسجي متوسط للبطاقات
  static const Color darkBackground = Color(0xFF1A0033);

  // الألوان الذهبية المزخرفة
  static const Color primaryGold = Color(0xFFD4AF37); // ذهبي كلاسيكي
  static const Color accentGold = Color(0xFFFFD700); // ذهبي مشرق للأزرار والتوهج
  static const Color textGold = Color(0xFFE6CA65);

  // النصوص والخلفيات الشفافة
  static const Color textWhite = Color(0xFFF5F5F5);
  static const Color cardSurface = Color(0x333B1E54); // بنفسجي مائل للشفافية
}

void main() {
  runApp(const AcademicSystemApp());
}

class AcademicSystemApp extends StatelessWidget {
  const AcademicSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام الجدول الأكاديمي والأرشيف الذكي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        primaryColor: AppColors.primaryPurple,
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // متحكمات حقول إدخال الأستاذ
  final _profNameController = TextEditingController();
  final _profPhoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _profNameController.dispose();
    _profPhoneController.dispose();
    super.dispose();
  }

  // --- ربط الباك إند والسريان البرمجي (Backend Data Flow) ---

  /// 1. مسار الطالب: تصوير البطاقة واستخراج الـ OCR ومعرف الجهاز (Device MAC)
  Future<void> _handleStudentOcrOnboarding() async {
    setState(() => _isLoading = true);

    // محاكاة قراءة الرقم الأكاديمي التقاط الـ MAC Address
    const String simulatedStudentId = "20261055";
    const String simulatedDeviceMac = "A1:B2:C3:D4:E5:F6";

    // إعداد طلب الـ JSON لسيرفر FastAPI (Python)
    final requestBody = {
      "action": "student_onboarding",
      "student_id": simulatedStudentId,
      "device_mac": simulatedDeviceMac,
    };

    debugPrint("Sending JSON to FastAPI: ${jsonEncode(requestBody)}");

    // محاكاة الاتصال بالخادم
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!mounted) return;
    _showSnackBar(
      "تم مسح البطاقة بنجاح! تم التقاط الرقم ($simulatedStudentId) والربط بالجهاز ($simulatedDeviceMac).",
      isError: false,
    );
  }

  /// 2. مسار الأستاذ: طلب تفعيل الحساب لدى المشرف
  Future<void> _handleProfessorActivationRequest() async {
    final name = _profNameController.text.trim();
    final phone = _profPhoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      _showSnackBar("يرجى إدخال جميع الحقول المطلوبة لأستاذ المادة", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final requestBody = {
      "action": "professor_activation_request",
      "full_name": name,
      "phone_number": phone,
      "status": "pending_verification"
    };

    debugPrint("Sending Professor Request: ${jsonEncode(requestBody)}");

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!mounted) return;

    // نافذة تنبيه أنيقة باللون البنفسجي والذهبي
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        title: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: AppColors.accentGold, size: 28),
            SizedBox(width: 10),
            Text(
              "تم إرسال الطلب",
              style: TextStyle(color: AppColors.textGold, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "تم إرسال طلبكم بنجاح، سيقوم مسؤول النظام بمراجعة البيانات وتفعيل الحساب عبر البريد الجامعي.",
          style: TextStyle(color: AppColors.textWhite, fontSize: 14, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.primaryPurple,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("حسناً", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red[900] : AppColors.secondaryPurple,
        content: Text(
          message,
          style: TextStyle(color: isError ? Colors.white : AppColors.textGold),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: isError ? Colors.red : AppColors.primaryGold),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية التدرج الانسيابي (Linear Gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.secondaryPurple,
                  AppColors.primaryPurple,
                  AppColors.darkBackground,
                ],
              ),
            ),
          ),

          // 2. زخارف هندسية خفيفة في الزوايا (Watermark Patterns)
          Positioned(
            top: -40,
            right: -40,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGold, width: 3),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentGold, width: 2),
                ),
              ),
            ),
          ),

          // 3. محتوى الشاشة مقسم إلى ثلاثة أجزاء عمودية متناسقة
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ===== أولاً: الجزء العلوي (Header) =====
                    const HeaderSection(),

                    const SizedBox(height: 25),

                    // ===== ثانياً: الجزء الأوسط (Body - Cards) =====
                    // بطاقة حساب الطالب
                    StudentAccessCard(
                      onOcrTap: _handleStudentOcrOnboarding,
                      onManualTap: () {
                        _showSnackBar("توجيه لشاشة الإدخال اليدوي للطالب...");
                      },
                    ),

                    const SizedBox(height: 20),

                    // بطاقة حساب الأستاذ
                    ProfessorAccessCard(
                      nameController: _profNameController,
                      phoneController: _profPhoneController,
                      onSubmit: _handleProfessorActivationRequest,
                    ),

                    const SizedBox(height: 30),

                    // ===== ثالثاً: الجزء السفلي (Footer) =====
                    const FooterSection(),
                  ],
                ),
              ),
            ),
          ),

          // شاشة التحميل فوق الواجهة عند الإرسال
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentGold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ================= مكونات الواجهة (Widgets Components) =================

/// الجزء العلوي (Header)
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شعار النظام الأكاديمي مع إطار دائرية ذهبي مزخرف
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentGold, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66D4AF37),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: const CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.primaryPurple,
            child: Icon(
              Icons.school_rounded,
              color: AppColors.accentGold,
              size: 42,
            ),
          ),
        ),
        const SizedBox(height: 15),

        // العنوان الرئيسي
        const Text(
          "نظام الجدول الأكاديمي والأرشيف الذكي",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textGold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),

        // العنوان الفرعي
        const Text(
          "مرحباً بك، يرجى اختيار نوع الحساب للمتابعة",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

/// بطاقة "حساب طالب" (Student Access Card)
class StudentAccessCard extends StatelessWidget {
  final VoidCallback _onOcrTap;
  final VoidCallback _onManualTap;

  const StudentAccessCard({
    super.key,
    required VoidCallback onOcrTap,
    required VoidCallback onManualTap,
  })  : _onOcrTap = onOcrTap,
        _onManualTap = onManualTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.6), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.badge_outlined, color: AppColors.accentGold, size: 26),
              SizedBox(width: 10),
              Text(
                "حساب طالب (Student Access)",
                style: TextStyle(
                  color: AppColors.textGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.primaryGold, thickness: 0.5, height: 20),

          // الخيار 1: زر ذهبي عريض لتصوير البطاقة الجامعية
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
            ),
            onPressed: _onOcrTap,
            icon: const Icon(Icons.camera_alt_rounded, size: 20),
            label: const Text(
              "تسجيل آلي عبر تصوير البطاقة الجامعية",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
          ),
          const SizedBox(height: 10),

          // الخيار 2: زر شفاف بحدود ذهبية للإدخال اليدوي
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textGold,
              side: const BorderSide(color: AppColors.primaryGold, width: 1),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _onManualTap,
            icon: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.accentGold),
            label: const Text(
              "إدخال البيانات يدوياً",
              style: TextStyle(fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة "حساب أستاذ" (Professor Access Card)
class ProfessorAccessCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback onSubmit;

  const ProfessorAccessCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.6), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.school_outlined, color: AppColors.accentGold, size: 26),
              SizedBox(width: 10),
              Text(
                "حساب أستاذ (Professor Access)",
                style: TextStyle(
                  color: AppColors.textGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.primaryGold, thickness: 0.5, height: 20),

          // حقل إدخال الاسم الثلاثي
          TextField(
            controller: nameController,
            style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
            decoration: InputDecoration(
              labelText: "الاسم الثلاثي للأستاذ",
              labelStyle: const TextStyle(color: AppColors.textGold, fontSize: 13),
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.accentGold, size: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryGold.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accentGold, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // حقل إدخال رقم المحمول (الواتس آب)
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
            decoration: InputDecoration(
              labelText: "رقم المحمول المربوط بحساب الواتس آب",
              labelStyle: const TextStyle(color: AppColors.textGold, fontSize: 13),
              prefixIcon: const Icon(Icons.phone_android_outlined, color: AppColors.accentGold, size: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryGold.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accentGold, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // الزر الرئيسي لإرسال طلب التفعيل
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryPurple,
              foregroundColor: AppColors.textGold,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.primaryGold, width: 1.5),
              ),
              elevation: 3,
            ),
            onPressed: onSubmit,
            icon: const Icon(Icons.send_rounded, size: 18, color: AppColors.accentGold),
            label: const Text(
              "إرسال طلب التفعيل إلى الإدارة",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// الجزء السفلي (Footer)
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.security_rounded, color: AppColors.textGold, size: 14),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            "جميع البيانات محمية ومربوطة بمعرف الجهاز لتأمين الحسابات (Device Binding)",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGold,
              fontSize: 11,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}