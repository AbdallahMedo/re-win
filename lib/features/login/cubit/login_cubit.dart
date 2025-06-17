import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth_services.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthServices _authServices;
  bool rememberMe = false;

  LoginCubit(this._authServices) : super(LoginInitial()) {
    _checkPersistedLogin();
  }

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
    phone = phone.trim();
    password = password.trim();

    try {
      final uid = await _authServices.signIn(phone, password);

      if (uid != null) {
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
        emit(LoginSuccess(uid)); // Now passing UID to success state
      } else {
        emit( LoginFailure("Invalid phone or password."));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found for this phone number.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Try again.";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
      }
      emit(LoginFailure(errorMessage));
    } catch (e) {
      emit(LoginFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('phone');
      await prefs.remove('password');
      await _authServices.signOut();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure("Logout failed: ${e.toString()}"));
    }
  }}