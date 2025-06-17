import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';
import '../../../../services/auth_services.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthServices authServices;
  RegisterCubit(this.authServices) : super(RegisterInitial());

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      final user = await authServices.signUp(firstName, lastName, phone, password);
      if (user != null) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure("Registration failed. Try again."));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
