import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nopp/main.dart';

void main() {
  testWidgets('onboarding screen opens manual student input', (tester) async {
    await tester.pumpWidget(const AcademicSystemApp());

    expect(find.text('نظام الجدول الأكاديمي والأرشيف الذكي'), findsOneWidget);

    await tester.tap(find.text('إدخال البيانات يدوياً'));
    await tester.pumpAndSettle();

    expect(find.text('تسجيل بيانات الطالب'), findsOneWidget);
    expect(find.text('الاسم الرباعي'), findsOneWidget);
  });

  testWidgets('student OCR action shows and dismisses loading overlay',
      (tester) async {
    await tester.pumpWidget(const AcademicSystemApp());

    await tester.tap(find.text('تسجيل آلي عبر تصوير البطاقة الجامعية'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('تم مسح البطاقة بنجاح'), findsOneWidget);
  });
}
