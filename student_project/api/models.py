from django.db import models

class Student(models.Model):
    student_id = models.CharField(max_length=50, unique=True)
    full_name = models.CharField(max_length=100)
    major = models.CharField(max_length=50)
    device_mac = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        db_table = 'students' # إجبار ديجانجو على استخدام جدول students الموجود في الصورة