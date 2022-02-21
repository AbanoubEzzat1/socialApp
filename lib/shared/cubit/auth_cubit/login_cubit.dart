import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/auth_cubit/login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  //late ShopLoginModel loginModel;
  bool isbassword = true;
  IconData suffex = Icons.visibility_off_outlined;
  void changePaasswordVisibility() {
    isbassword = !isbassword;
    suffex =
        isbassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(LoginchangePaasswordVisibilityState());
  }

  // void userLogin({
  //   required String email,
  //   required String password,
  // }) {
  //   emit(LoginLoadingState());
  //   FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   )
  //       .then((value) {
  //     print(value.user!.email);
  //     print(value.user!.uid);
  //     emit(LoginSuccessState());
  //   }).catchError((e) {
  //     print(e.toString());
  //     emit(LoginErorrState(e.toString()));
  //   });
  // }

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        emit(LoginSuccessState(value.user!.uid));
        print(value.user!.email);
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      emit(LoginErorrState(e.toString()));
    }
  }
}
