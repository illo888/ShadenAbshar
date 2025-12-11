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
        city: state!.city,
        phone: state!.phone,
        scenario: scenario,
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
