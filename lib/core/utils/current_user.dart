import 'dart:convert';
import 'shared_prefs.dart';
import 'package:waitwise/data/models/user_model.dart';

UserModel? getCurrentUser() {
  final userJson = prefs.getString('currentUser');
  if (userJson == null) return null;
  return UserModel.fromJson(jsonDecode(userJson));
}

void saveCurrentUser(UserModel user) {
  prefs.setString('currentUser', jsonEncode(user.toJson()));
}

void markOnboardingDone() {
  prefs.setBool('onboarding_done', true);
}
