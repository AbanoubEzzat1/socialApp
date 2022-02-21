import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/modules/social_auth/login_screen.dart';
import 'package:social_app/modules/social_layout/social_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/auth_cubit/register_cubit.dart';
import 'package:social_app/shared/cubit/auth_cubit/registerstates.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (BuildContext context, state) {
          if (state is RegisterCreateUserSuccessState) {
            navigateAndFinish(
              context,
              SocialLayoutScreen(),
            );
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Register now to communicate with friends",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Colors.grey,
                                      fontSize: 22,
                                    ),
                          ),
                          const SizedBox(height: 20),
                          deffaultFormField(
                            controller: nameController,
                            labelText: "User Name",
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Name must not be empty";
                              }
                            },
                            prefix: Icons.person,
                            type: TextInputType.name,
                          ),
                          const SizedBox(height: 20),
                          deffaultFormField(
                            controller: emailController,
                            labelText: "Email Address",
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Email must not be empty";
                              }
                            },
                            prefix: Icons.email_outlined,
                            type: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          deffaultFormField(
                            controller: passwordController,
                            isPassword: RegisterCubit.get(context).isbassword,
                            labelText: "Password",
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Password is too short';
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  //image: imageController.text,
                                );
                              }
                            },
                            prefix: Icons.lock,
                            suffix: RegisterCubit.get(context).suffex,
                            suffixPressed: () {
                              RegisterCubit.get(context)
                                  .changePaasswordVisibility();
                            },
                          ),
                          const SizedBox(height: 20),
                          deffaultFormField(
                            controller: phoneController,
                            labelText: "Phone",
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Phone must not be empty";
                              }
                            },
                            prefix: Icons.phone,
                            type: TextInputType.phone,
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  //image: imageController.text,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          BuildCondition(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => deffaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    //image: imageController.text,
                                  );
                                }
                              },
                              text: "register",
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "have an account ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              deffaultTextButton(
                                onPressed: () {
                                  navigateTo(
                                    context,
                                    LoginScreen(),
                                  );
                                },
                                text: "LOGIN",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
