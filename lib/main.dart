import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_auth/login_screen.dart';
import 'package:social_app/modules/social_layout/social_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/thems.dart';

import 'block_observer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  print(message.data.toString());
  showToast(text: "onMessageOpenedApp", state: ToastState.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print("************$token");
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(text: "onMessage", state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(text: "onMessageOpenedApp", state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  BlocOverrides.runZoned(
    () async {
      await CacheHelper.init();
      late Widget widget;
      uId = CacheHelper.getData(key: 'uId');
      if (uId != null) {
        widget = SocialLayoutScreen();
      } else {
        widget = LoginScreen();
      }
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  late final Widget startWidget;

  MyApp({required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUserData()
            ..getPosts(),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialAppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          theme: lightThem,
          debugShowCheckedModeBanner: false,
          home: startWidget,
        ),
      ),
    );
  }
}
