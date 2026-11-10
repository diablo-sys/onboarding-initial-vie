import 'package:flutter/material.dart';

/// هويّة الألوان والتنسيق البصري (AppColors)
class AppColors {
  static const Color primaryPurple = Color(0xFF2A004E);
  static const Color secondaryPurple = Color(0xFF3B1E54);
  static const Color darkBackground = Color(0xFF1A0033);
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color textGold = Color(0xFFE6CA65);
  static const Color textWhite = Color(0xFFF5F5F5);
  static const Color cardSurface = Color(0x333B1E54);
}

class StudentHomeDashboard extends StatefulWidget {
  final String studentName;
  final String studentId;
  final String department;

  const StudentHomeDashboard({
    super.key,
    this.studentName = "عمر مختار الشعبي",
    this.studentId = "20261055",
    this.department = "علوم الحاسب (CS)",
  });

  @override
  State<StudentHomeDashboard> createState() => _StudentHomeDashboardState();
}

class _StudentHomeDashboardState extends State<StudentHomeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم الطالب',
          style: TextStyle(color: AppColors.textGold, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondaryPurple,
        iconTheme: const IconThemeData(color: AppColors.accentGold),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. التدرج الخلفي الانسيابي
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

          // 2. زخارف خلفية خفيفة
          const Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.1,
              child: _DecorativeCircle(size: 220, color: AppColors.primaryGold, width: 3),
            ),
          ),

          // 3. المحتوى الرئيسي
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // بطاقة معلومات الطالب (Header Info)
                  _StudentProfileHeader(
                    name: widget.studentName,
                    id: widget.studentId,
                    department: widget.department,
                  ),

                  const SizedBox(height: 25),

                  // المربع الأول: جدول المحاضرات والقاعات
                  _DashboardActionCard(
                    title: "جدولي الأكاديمي",
                    subtitle: "عرض جدول المحاضرات والقاعات الأسبوعية",
                    icon: Icons.calendar_month_rounded,
                    onTap: () {
                      _showActionMessage(context, "الانتقال إلى جدول المحاضرات...");
                    },
                  ),

                  const SizedBox(height: 16),

                  // المربع الثاني: تسجيل الحضور (مسح الـ QR المتغير)
                  _DashboardActionCard(
                    title: "تسجيل الحضور",
                    subtitle: "فتح الكاميرا لمسح رمز الحضور (Dynamic QR)",
                    icon: Icons.qr_code_scanner_rounded,
                    isHighlighted: true,
                    onTap: () {
                      _showActionMessage(context, "جاري فتح الكاميرا لمسح رمز الأستاذ...");
                    },
                  ),

                  const SizedBox(height: 16),

                  // المربع الثالث: ما تم إنجازه (Progress) مع قوائم منسدلة
                  const _ProgressSectionCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActionMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.primaryGold),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// ودجت لعرض رأس معلومات الطالب
class _StudentProfileHeader extends StatelessWidget {
  final String name;
  final String id;
  final String department;

  const _StudentProfileHeader({
    required this.name,
    required this.id,
    required this.department,
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
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryPurple,
            child: Icon(Icons.person_rounded, color: AppColors.accentGold, size: 36),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textGold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "الرقم الأكاديمي: $id",
                  style: const TextStyle(color: AppColors.textWhite, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  department,
                  style: const TextStyle(color: AppColors.textGold, fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// مربع تفاعلي عام للخدمات الرئيسية
class _DashboardActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _DashboardActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isHighlighted ? AppColors.secondaryPurple.withOpacity(0.8) : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHighlighted ? AppColors.accentGold : AppColors.primaryGold.withOpacity(0.5),
              width: isHighlighted ? 2 : 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGold, width: 1),
                ),
                child: Icon(icon, color: AppColors.accentGold, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.textWhite, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryGold, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// مربع "ما تم إنجازه (Progress)" مع قوائم منسدلة تفاعلية للمقررات
class _ProgressSectionCard extends StatefulWidget {
  const _ProgressSectionCard();

  @override
  State<_ProgressSectionCard> createState() => _ProgressSectionCardState();
}

class _ProgressSectionCardState extends State<_ProgressSectionCard> {
  // بيانات تجريبية للمواد ونسب أو تفاصيل ما تم إنجازه من المنهج
  final List<Map<String, dynamic>> _subjectsProgress = [
    {
      'subject': 'شبكات الحاسب المتقدمة',
      'progress': '75%',
      'topics': ['التوجيه الاحترافي OSPF', 'إعدادات VLANs', 'أمن المنهجيات والـ Access Lists'],
    },
    {
      'subject': 'تطوير تطبيقات الويب والهواتف',
      'progress': '60%',
      'topics': ['أساسيات Flutter و Dart', 'ربط واجهات الواجهة الخلفية FastAPI', 'إدارة قواعد البيانات SQLite/MySQL'],
    },
    {
      'subject': 'أمن المعلومات والسيبراني',
      'progress': '85%',
      'topics': ['مفاهيم التشفير المتقدمة', 'اختبار الاختراق الأخلاقي', 'سياسات الحماية وجدران الحماية'],
    },
  ];

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
          const Row(
            children: [
              Icon(Icons.trending_up_rounded, color: AppColors.accentGold, size: 26),
              SizedBox(width: 10),
              Text(
                "ما تم إنجازه (Progress)",
                style: TextStyle(
                  color: AppColors.textGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.primaryGold, thickness: 0.5, height: 20),
          const Text(
            "قائمة المواد الدراسية وما تم إنجازه من المنهج الأكاديمي:",
            style: TextStyle(color: AppColors.textWhite, fontSize: 12),
          ),
          const SizedBox(height: 12),
          // توليد قوائم منسدلة لكل مادة ديناميكياً
          ..._subjectsProgress.map((item) {
            final subject = (item['subject'] as String?) ?? '';
            final progress = (item['progress'] as String?) ?? '';
            final topics = List<String>.from((item['topics'] as List<dynamic>? ?? const []));

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ExpansionTile(
                  collapsedIconColor: AppColors.accentGold,
                  iconColor: AppColors.accentGold,
                  title: Text(
                    subject,
                    style: const TextStyle(color: AppColors.textGold, fontSize: 13.5, fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      progress,
                      style: const TextStyle(color: AppColors.primaryPurple, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(color: Colors.white24, height: 10),
                          const Text(
                            "الوحدات والمواضيع المنجزة:",
                            style: TextStyle(color: AppColors.textWhite, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          ...topics.map((topic) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: AppColors.accentGold, size: 14),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        topic,
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// عنصر إضافي للزخرفة الخلفية لضمان توافقية الكود
class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double width;

  const _DecorativeCircle({
    required this.size,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: width),
      ),
    );
  }
}