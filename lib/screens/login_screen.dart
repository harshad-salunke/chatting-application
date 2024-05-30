import 'dart:developer';
import 'dart:io';

import 'package:chat_application/models/chat_user.dart';
import 'package:chat_application/screens/mainSubScreens/home_screen.dart';
import 'package:chat_application/screens/main_screen.dart';
import 'package:chat_application/services/providers/firebase_auth_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../widgets/global/dialogs.dart';
import '../main.dart';
import '../services/providers/service_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  _handleGoogleBtnClick(FirebaseAuthProvider authProvider,
      ServiceProvider serviceProvider) async {

    Dialogs.showCircularProgressBar(context);

    UserCredential? user = await authProvider.signInWithGoogle();
    if (user != null) {
      Navigator.pop(context);

      Dialogs.showProgressBarIcons(context,'Loading');

      User signInuser = user.user!;

      ChatUser currentUser = ChatUser(
          image: signInuser.photoURL ?? '',
          name: signInuser.displayName ?? '',
          createdAt: '',
          isOnline: true,
          id: signInuser.uid,
          email: signInuser.email ?? '');

      bool isUserExist =await serviceProvider.isUserExist(currentUser);

      if (!isUserExist) {
      print('user not exist');
        await serviceProvider.saveUserDetails(currentUser);
      }

      Navigator.pop(context);

      serviceProvider.fetchAllChatUsers();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));

    } else {
      if (mounted) {
        Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FirebaseAuthProvider,ServiceProvider>(builder: (_, authProvider,serviceProvider, __) {
      return Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Welcome to Chat App'),
        ),

        body: Stack(children: [
          
          Positioned(
            top: 20,
            right: 0,
            left: 0,
            child: Gif(
              image: AssetImage("assets/gifs/chat.gif"),
              height: 400,
              width: mobileScreenSize.width,
              autostart: Autostart.once,
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 223, 255, 187),
                        shape: const StadiumBorder(),
                        elevation: 1),
                    onPressed: () {
                      _handleGoogleBtnClick(authProvider,serviceProvider);
                    },
                    icon: Image.asset('assets/images/google.png',
                        height: mobileScreenSize.height * .03),
                    label: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(text: 'Login with '),
                            TextSpan(
                                text: 'Google',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ]),
                    )),
              )),
        ]),
      );
    });
  }
}
