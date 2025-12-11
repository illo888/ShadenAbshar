import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/models/service_model.dart';
import '../config/theme/colors.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceCard({
    required this.service,
    this.onTap,
    super.key,
  });

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'badge':
        return Icons.badge;
      case 'car':
        return Icons.directions_car;
      case 'passport':
        return Icons.description;
      case 'business':
        return Icons.business;
      default:
        return Icons.document_scanner;
    }
  }

  Color _getStatusColor(String status) {
    return status == 'نشط' ? AppColors.success : AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = service.status == 'نشط';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isActive 
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.textLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(service.icon),
                  color: isActive ? AppColors.primary : AppColors.textLight,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Service Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.nameAr,
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (service.nameEn != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        service.nameEn!,
                        style: GoogleFonts.tajawal(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'تنتهي في: ${service.expiryDate}',
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(service.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service.status,
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(service.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
