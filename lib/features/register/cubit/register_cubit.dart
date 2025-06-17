import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';
import '../../../../services/auth_services.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthServices _authServices;

  RegisterCubit(this._authServices) : super(RegisterInitial());

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      // Get UID from auth service
      final uid = await _authServices.signUp(firstName, lastName, phone, password);

      if (uid != null) {
        // Emit success with UID
        emit(RegisterSuccess(uid));
      } else {
        emit( RegisterFailure("Registration failed. Please try again."));
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific auth errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This phone number is already registered";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak";
          break;
        default:
          errorMessage = "Registration failed: ${e.message}";
      }
      emit(RegisterFailure(errorMessage));
    } catch (e) {
      // Handle all other errors
      emit(RegisterFailure("An unexpected error occurred: $e"));
    }
  }

  // Optional: Add method to clear errors
  void clearError() {
    if (state is RegisterFailure) {
      emit(RegisterInitial());
    }
  }
}