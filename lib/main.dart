import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), //لون خلفية التطبيق

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20), //نضيف مسافة بين المحتوى والحواف

            child: Column(
              children: [
                const SizedBox(height: 30), //مساف راسية
                // الأيقونة
                Container(
                  width: 100,
                  height: 100,

                  decoration: BoxDecoration(
                    //تنسيقات الحاوية
                    color: Colors.blue.withOpacity(0.15),
                    shape: BoxShape.circle, //الحاوية تكون دائرة

                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.blue,
                  ), //ايقونة الشخص
                ),

                const SizedBox(height: 15),

                const Text(
                  "عمر احمد الواسعي",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text(
                  "طالب جامعي",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 30),

                // الكارد الأول
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      18,
                    ), //يجعل زوايا الكارد دائرية
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.email,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "البريد الإلكتروني",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "example@gmail.com",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // الكارد الثاني
                Card(
                  elevation: 5,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.phone,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //يا عمر كيف أنت اليوم
                          children: [
                            Text(
                              "namper  الهاتف",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "775 269 419",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // كارد ثالث
                Card(
                  elevation: 5,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.school,
                            color: Colors.orange,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "التخصص",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "تقنية المعلومات",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // الحاوية السفلية
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.star, color: Colors.amber),

                      SizedBox(width: 8),

                      Text(
                        "مرحباً بك في ملفك الشخصي",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
