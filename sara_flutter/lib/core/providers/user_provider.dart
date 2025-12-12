import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }

  void updateScenario(String scenario) {
    if (state != null) {
      state = UserModel(
        saudiId: state!.saudiId,
        name: state!.name,
        nameEn: state!.nameEn,
        birthDate: state!.birthDate,
        nationality: state!.nationality,
        city: state!.city,
        phone: state!.phone,
        scenario: scenario,
        services: state!.services,
        notifications: state!.notifications,
      );
    }
  }

  void clearUser() {
    state = null;
  }

  bool get isAuthenticated => state != null;
  
  String? get currentScenario => state?.scenario;
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});
