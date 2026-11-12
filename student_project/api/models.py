from django.db import models

class Student(models.Model):
    student_id = models.CharField(max_length=50, primary_key=True) # ربط المفتاح الأساسي الفعلي
    full_name = models.CharField(max_length=100)
    department = models.CharField(max_length=100)  # مطابقة لـ VARCHAR(100) في القاعدة
    level = models.CharField(max_length=50, blank=True, null=True)
    device_unique_id = models.CharField(max_length=255, blank=True, null=True)  # مطابقة لحجم الحقل في القاعدة
    status = models.CharField(max_length=50, default='inactive')

    class Meta:
        db_table = 'students'  # إجبار دجانجو على استخدام جدول students الموجود في القاعدة
        managed = False        # منع دجانجو من محاولة عمل migrations تعديلية على الجدول المكتوب بالـ SQL