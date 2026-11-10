from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Student

@api_view(['POST'])
def register_student(request):
    student_id = str(request.data.get('student_id', '')).strip()
    full_name = str(request.data.get('full_name', '')).strip()
    department = str(request.data.get('department', '')).strip()
    device_id = str(request.data.get('device_id', '')).strip() # استقبال معرف الجهاز من الفلاتر

    try:
        student = Student.objects.filter(student_id=student_id).first()

        if not student:
            return Response({"error": "الرقم الأكاديمي غير مسجل في قاعدة البيانات."}, status=status.HTTP_400_BAD_REQUEST)

        # التحقق من تطابق الاسم والقسم
        if student.full_name.strip() != full_name or student.major.strip().lower() != department.lower():
            return Response({"error": "الاسم أو القسم الدراسي غير مطابق للبيانات المسجلة."}, status=status.HTTP_400_BAD_REQUEST)

        # منطق ربط الجهاز (Device Binding)
        if not student.device_mac:
            # أول مرة يسجل الدخول، نقوم بتخزين معرف جهازه الفريد
            student.device_mac = device_id
            student.save()
        elif student.device_mac != device_id:
            # محاولة الدخول من جهاز آخر مختلف
            return Response({"error": "هذا الحساب مرتبط بهاتف آخر ولا يمكن تسجيل الدخول منه."}, status=status.HTTP_403_FORBIDDEN)

        return Response({"message": "تم التحقق وتسجيل الدخول بنجاح!"}, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)