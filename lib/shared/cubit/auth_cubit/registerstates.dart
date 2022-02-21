abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  // final RegisterModel regesterModel;
  // RegisterSuccessState(this.regesterModel);
}

class RegisterErorrState extends RegisterStates {
  final String erorr;
  RegisterErorrState(this.erorr);
}

class RegisterCreateUserSuccessState extends RegisterStates {}

class RegisterCreateUserErorrState extends RegisterStates {
  final String erorr;
  RegisterCreateUserErorrState(this.erorr);
}

class RegisterchangePaasswordVisibilityState extends RegisterStates {}
