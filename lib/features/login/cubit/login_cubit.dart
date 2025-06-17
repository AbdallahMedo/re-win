import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_services.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthServices _authServices;

  LoginCubit(this._authServices) : super(LoginInitial()) {
    _checkPersistedLogin();
  }

  bool rememberMe = false;

  void toggleRememberMe(bool value) {
    rememberMe = value;
    emit(LoginInitial());
  }

  Future<void> _checkPersistedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final phone = prefs.getString('phone') ?? '';
    final password = prefs.getString('password') ?? '';

    if (isLoggedIn && phone.isNotEmpty && password.isNotEmpty) {
      await login(phone: phone, password: password);
    }
  }

  Future<void> login({required String phone, required String password}) async {
    emit(LoginLoading());

    try {
      phone = phone.trim();
      password = password.trim();

      final user = await _authServices.signIn(phone, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('phone', phone);
          await prefs.setString('password', password);
        } else {
          await prefs.remove('isLoggedIn');
          await prefs.remove('phone');
          await prefs.remove('password');
        }
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Invalid phone or password."));
      }
    } on FirebaseAuthException catch (e) {
      // ... (keep existing error handling)
    } catch (e) {
      // ... (keep existing error handling)
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('phone');
    await prefs.remove('password');
    emit(LoginInitial());
  }
}