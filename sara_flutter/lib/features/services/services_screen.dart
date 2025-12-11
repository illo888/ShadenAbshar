import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/user_model.dart';
import '../../core/models/service_model.dart';
import '../../core/constants/mock_data.dart';
import '../../config/theme/colors.dart';
import '../../widgets/service_card.dart';

enum FilterType { all, active, expired }

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _query = '';
  FilterType _filter = FilterType.all;
  final TextEditingController _searchController = TextEditingController();

  List<ServiceModel> get _filteredServices {
    final UserModel user = mockUserData;
    List<ServiceModel> filtered = user.services;

    // Apply search filter
    if (_query.isNotEmpty) {
      filtered = filtered.where((s) {
        final nameAr = s.nameAr.toLowerCase();
        final nameEn = s.nameEn?.toLowerCase() ?? '';
        final query = _query.toLowerCase();
        return nameAr.contains(query) || nameEn.contains(query);
      }).toList();
    }

    // Apply status filter
    switch (_filter) {
      case FilterType.active:
        filtered = filtered.where((s) => s.status == 'نشط').toList();
        break;
      case FilterType.expired:
        filtered = filtered.where((s) => s.status == 'منتهية').toList();
        break;
      case FilterType.all:
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = mockUserData;
    final activeCount = user.services.where((s) => s.status == 'نشط').length;
    final expiredCount = user.services.where((s) => s.status == 'منتهية').length;

    return Scaffold(
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خدماتك الحكومية',
                      style: GoogleFonts.tajawal(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'إدارة جميع خدماتك في مكان واحد',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن خدمة...',
                          hintStyle: GoogleFonts.tajawal(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _query = '';
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip(
                    'الكل (${user.services.length})',
                    FilterType.all,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'النشطة ($activeCount)',
                    FilterType.active,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'المنتهية ($expiredCount)',
                    FilterType.expired,
                  ),
                ],
              ),
            ),
          ),

          // Services List
          Expanded(
            child: _filteredServices.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      return ServiceCard(
                        service: _filteredServices[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, FilterType type) {
    final isSelected = _filter == type;
    return InkWell(
      onTap: () {
        setState(() {
          _filter = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد خدمات',
            style: GoogleFonts.tajawal(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _query.isNotEmpty
                ? 'لم نجد نتائج لبحثك'
                : 'لا توجد خدمات في هذه الفئة',
            style: GoogleFonts.tajawal(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
