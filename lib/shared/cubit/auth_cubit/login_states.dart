import 'package:social_app/models/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String? uId;

  LoginSuccessState(this.uId);
}

class LoginErorrState extends LoginStates {
  final String erorr;
  LoginErorrState(this.erorr);
}

class LoginchangePaasswordVisibilityState extends LoginStates {}
