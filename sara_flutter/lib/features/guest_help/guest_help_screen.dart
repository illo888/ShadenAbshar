import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/colors.dart';

class GuestHelpScreen extends StatefulWidget {
  const GuestHelpScreen({super.key});

  @override
  State<GuestHelpScreen> createState() => _GuestHelpScreenState();
}

class _GuestHelpScreenState extends State<GuestHelpScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _relativeNameController = TextEditingController();
  String _status = '';
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    _relativeNameController.dispose();
    super.dispose();
  }

  Future<void> _requestHelp() async {
    setState(() {
      _status = '';
      _loading = true;
    });

    // Validate ID
    if (_idController.text.trim().isEmpty) {
      setState(() {
        _status = 'الرجاء إدخال رقم الهوية';
        _loading = false;
      });
      return;
    }

    // Simulate checking travel record
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if user is inside Saudi Arabia
    final isOutside = _idController.text.startsWith('2'); // Mock logic
    if (!isOutside) {
      setState(() {
        _status = 'يبدو أنك داخل السعودية. يمكنك استخدام نفاذ/توكلنا للوصول الكامل.';
        _loading = false;
      });
      return;
    }

    // Validate relative name
    if (_relativeNameController.text.trim().isEmpty) {
      setState(() {
        _status = 'الرجاء إدخال اسم قريب من الدرجة الأولى أو الثانية';
        _loading = false;
      });
      return;
    }

    // Simulate matching relative
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock success
    setState(() {
      _status = 'تم فتح قناة تواصل آمنة مع ${_relativeNameController.text}. رقم القناة: CH-${DateTime.now().millisecondsSinceEpoch}';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Text(
                      'مساعدة محدودة للزوار',
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سنساعدك بالوصول المحدود في الحالات الطارئة',
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  
                  // ID Input
                  Text(
                    'رقم الهوية الوطنية',
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: '1XXXXXXXXX',
                        hintStyle: GoogleFonts.tajawal(
                          color: AppColors.textLight,
                        ),
                        prefixIcon: const Icon(
                          Icons.badge,
                          color: AppColors.textLight,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Relative Name Input
                  Text(
                    'اسم قريب من الدرجة الأولى/الثانية',
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _relativeNameController,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب الاسم الكامل',
                        hintStyle: GoogleFonts.tajawal(
                          color: AppColors.textLight,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.textLight,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  ElevatedButton(
                    onPressed: _loading ? null : _requestHelp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'طلب المساعدة',
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  
                  // Status Message
                  if (_status.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _status,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Help Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بدون وصول؟',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'يمكننا تزويدك بأرقام ومواقع سفارات السعودية بالخارج، أو مساعدتك للوصول المحدود عبر أقاربك.',
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
