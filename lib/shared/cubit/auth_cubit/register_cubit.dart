import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/auth_cubit/registerstates.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isbassword = true;
  IconData suffex = Icons.visibility_off_outlined;
  void changePaasswordVisibility() {
    isbassword = !isbassword;
    suffex =
        isbassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(RegisterchangePaasswordVisibilityState());
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
        isEmailVerified: false,
      );
      emit(RegisterSuccessState());
    }).catchError((erorr) {
      emit(RegisterErorrState(erorr));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
    String? image,
    String? cover,
    String? bio,
    required bool isEmailVerified,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: image,
      cover: cover,
      bio: bio,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(
          model.toMap(),
        )
        .then((value) {
      emit(RegisterCreateUserSuccessState());
    }).catchError((erorr) {
      print(erorr);
      emit(RegisterCreateUserErorrState(erorr));
    });
  }
}



// SocialUserModel(
    //   name = name,
    //   email = email,
    //   phone = phone,
    //   uId = uId,
    //   image = image,
    //   //"https://image.freepik.com/free-photo/old-wooden-texture-background-vintage_55716-1138.jpg?w=740",
    //   cover = cover,
    //   //"https://image.freepik.com/free-photo/islamic-new-year-pattern-background_23-2148950279.jpg?w=740",
    //   bio = bio,
    //   //"Weite your bio",
    //   isEmailVerified = isEmailVerified,
    // );