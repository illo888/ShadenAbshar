import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/user_model.dart';
import '../../core/constants/mock_data.dart';
import '../../config/theme/colors.dart';
import '../../widgets/ai_wave.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = mockUserData;
    final activeServices = user.services.where((s) => s.status == 'نشط').toList();
    final activeServiceNames = activeServices.take(2).map((s) => s.nameAr).join(' • ');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone, color: AppColors.primary),
                          onPressed: () {
                            final phone = user.phone ?? '800123456';
                            launchUrl(Uri.parse('tel:$phone'));
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'مرحباً بك',
                              style: GoogleFonts.tajawal(
                                fontSize: 14,
                                color: AppColors.textLight,
                              ),
                            ),
                            Text(
                              '${user.name.split(' ')[0]} 👋',
                              style: GoogleFonts.tajawal(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_outline, color: AppColors.primary),
                          onPressed: () => context.go('/profile'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // AI Wave Animation
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                alignment: Alignment.center,
                child: const AIWave(
                  state: WaveState.idle,
                  size: 220,
                ),
              ),
            ),

            // Start Chat Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ElevatedButton(
                  onPressed: () => context.go('/chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'ابدأ محادثة مع سارا',
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Quick Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لمحة سريعة',
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Services Card
                    _buildStatCard(
                      context,
                      title: 'الخدمات الجاهزة',
                      value: activeServices.length.toString(),
                      subtitle: activeServiceNames.isNotEmpty 
                          ? activeServiceNames 
                          : 'لا توجد خدمات مفعّلة حالياً',
                      icon: Icons.check_circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      chip: 'منصة أبشر',
                      onTap: () => context.go('/services'),
                    ),
                    const SizedBox(height: 12),
                    
                    // Notifications Card
                    _buildStatCard(
                      context,
                      title: 'التنبيهات الحرجة',
                      value: user.notifications.length.toString(),
                      subtitle: user.notifications.isNotEmpty
                          ? user.notifications.first.titleAr
                          : 'ما فيه تنبيهات جديدة',
                      icon: Icons.notifications_active,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      chip: user.notifications.isNotEmpty ? 'مطلوب متابعة' : 'كل شيء تحت السيطرة',
                      onTap: () => context.go('/profile'),
                    ),
                    const SizedBox(height: 12),
                    
                    // Safe Gate Card
                    _buildStatCard(
                      context,
                      title: 'البوابة الآمنة',
                      value: '0',
                      subtitle: 'فعّل البوابة الآمنة لتستقبل الأكواد فوراً',
                      icon: Icons.password,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      chip: 'يتطلب تفعيل',
                      onTap: () => context.go('/safe-gate'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required String chip,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chip,
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(icon, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.tajawal(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
