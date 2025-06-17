abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String uid;
   RegisterSuccess(this.uid);

  @override
  List<Object> get props => [uid];
}
class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
