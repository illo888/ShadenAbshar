import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/notification_model.dart';

final mockUserData = UserModel(
  saudiId: '1234567890',
  name: 'أحمد محمد العتيبي',
  nameEn: 'Ahmed Mohammed Al-Otaibi',
  birthDate: '1990-05-15',
  nationality: 'سعودي',
  city: 'الرياض',
  phone: '0551234567',
  scenario: 'in_saudi',
  services: [
    const ServiceModel(
      id: 1,
      nameAr: 'تجديد الهوية الوطنية',
      nameEn: 'National ID Renewal',
      status: 'نشط',
      expiryDate: '2026-03-20',
      icon: 'badge',
    ),
    const ServiceModel(
      id: 2,
      nameAr: 'رخصة القيادة',
      nameEn: 'Driving License',
      status: 'منتهية',
      expiryDate: '2024-08-10',
      icon: 'car',
    ),
    const ServiceModel(
      id: 3,
      nameAr: 'جواز السفر',
      nameEn: 'Passport',
      status: 'نشط',
      expiryDate: '2027-12-05',
      icon: 'passport',
    ),
    const ServiceModel(
      id: 4,
      nameAr: 'تأمين المركبات',
      nameEn: 'Vehicle Insurance',
      status: 'نشط',
      expiryDate: '2025-06-15',
      icon: 'car',
    ),
    const ServiceModel(
      id: 5,
      nameAr: 'سجل تجاري',
      nameEn: 'Commercial Registration',
      status: 'منتهية',
      expiryDate: '2024-11-30',
      icon: 'business',
    ),
  ],
  notifications: [
    const NotificationModel(
      id: 1,
      titleAr: 'تنبيه: موعد تجديد الرخصة',
      messageAr: 'رخصة القيادة الخاصة بك انتهت صلاحيتها',
      date: '2025-11-20',
    ),
    const NotificationModel(
      id: 2,
      titleAr: 'تذكير: تجديد السجل التجاري',
      messageAr: 'السجل التجاري الخاص بك سينتهي قريباً',
      date: '2025-11-15',
    ),
  ],
);
