import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';
import '../../config/constants.dart';
import '../../core/utils/scenario_utils.dart';
import '../../core/providers/user_provider.dart';
import '../../core/models/user_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _continueFlow() async {
    setState(() {
      _errorMessage = null;
    });

    final id = _idController.text.trim();

    // Validate Saudi ID
    if (!validateSaudiId(id)) {
      setState(() {
        _errorMessage = 'الهوية الوطنية غير صحيحة. يجب أن تكون 10 أرقام وتبدأ بـ 1';
      });
      return;
    }

    setState(() => _isVerifying = true);

    // Simulate Nafath/Absher verification (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Determine scenario based on last digit
    final scenario = determineScenario(id);

    // Generate user data based on scenario
    final userData = _generateUserFromScenario(id, scenario);

    // Save user data
    ref.read(userProvider.notifier).setUser(userData);

    setState(() => _isVerifying = false);

    // Route by scenario - AI first means Chat for most scenarios
    if (mounted) {
      if (scenario == AppConstants.scenarioElder) {
        // Elder goes to simplified screen
        context.go('/elder-mode');
      } else {
        // Everyone else goes to Chat first (AI-first approach)
        context.go('/chat');
      }
    }
  }

  UserModel _generateUserFromScenario(String saudiId, String scenario) {
    final scenarioNames = {
      AppConstants.scenarioSafeGate: 'أحمد المغترب',
      AppConstants.scenarioInSaudi: 'محمد السعيد',
      AppConstants.scenarioElder: 'عبدالله الكبير',
      AppConstants.scenarioGuest: 'زائر مساعد',
    };

    final scenarioCities = {
      AppConstants.scenarioSafeGate: 'لندن، المملكة المتحدة',
      AppConstants.scenarioInSaudi: 'الرياض',
      AppConstants.scenarioElder: 'جدة',
      AppConstants.scenarioGuest: 'غير محدد',
    };

    final scenarioPhones = {
      AppConstants.scenarioSafeGate: '+44 7700 900123',
      AppConstants.scenarioInSaudi: '+966 50 123 4567',
      AppConstants.scenarioElder: '+966 50 987 6543',
      AppConstants.scenarioGuest: 'غير متاح',
    };

    return UserModel(
      saudiId: saudiId,
      name: scenarioNames[scenario] ?? 'مستخدم',
      nameEn: scenarioNames[scenario] ?? 'User',
      birthDate: '1990-01-01',
      nationality: 'سعودي',
      city: scenarioCities[scenario] ?? 'غير محدد',
      phone: scenarioPhones[scenario] ?? 'غير متاح',
      scenario: scenario,
      services: [],
      notifications: [],
    );
  }

  void _activateGuestHelp() {
    // Direct navigation to Guest Help (for users without access)
    context.go('/guest-help');
  }

  Widget _buildTestUserCard(TestUser user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        dense: true,
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${user.saudiId}\n${user.description}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Icon(
          _getScenarioIcon(user.scenario),
          color: AppColors.primary,
        ),
        onTap: () {
          _idController.text = user.saudiId;
        },
      ),
    );
  }

  Widget _buildDemoCard({
    required String label,
    required String id,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _idController.text = id,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                id,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                child: Column(
                  children: [
                    const Text(
                      'مرحبا بك في سارة',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'المساعدة الذكية للخدمات الحكومية السعودية',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Label
                    const Text(
                      'رقم الهوية الوطنية (10 أرقام)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),

                    // Input field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _idController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: '1XXXXXXXXX',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.badge, color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          counterText: '',
                          errorText: _errorMessage,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Continue button
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isVerifying ? null : _continueFlow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isVerifying
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.login, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'متابعة عبر نفاذ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Demo IDs Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'معرفات تجريبية للاختبار',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Grid of demo cards
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.2,
                            children: [
                              _buildDemoCard(
                                label: 'البوابة الآمنة',
                                id: '1000000000',
                                icon: Icons.vpn_lock,
                              ),
                              _buildDemoCard(
                                label: 'محادثة سارا',
                                id: '1000000005',
                                icon: Icons.smart_toy,
                              ),
                              _buildDemoCard(
                                label: 'وضع كبار السن',
                                id: '1000000007',
                                icon: Icons.elderly,
                              ),
                              _buildDemoCard(
                                label: 'مساعدة ضيف',
                                id: '1000000009',
                                icon: Icons.help_outline,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Info text
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'آخر رقم: 0-2 (بوابة آمنة) • 3-6 (محادثة) • 7-8 (كبار سن) • 9 (ضيف)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Guest help link
                    TextButton(
                      onPressed: _activateGuestHelp,
                      child: const Text(
                        'لا أملك وصول — أحتاج مساعدة',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
