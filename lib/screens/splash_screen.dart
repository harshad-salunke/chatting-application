import 'dart:developer';

import 'package:chat_application/screens/mainSubScreens/home_screen.dart';
import 'package:chat_application/screens/main_screen.dart';
import 'package:chat_application/services/providers/firebase_auth_handler.dart';
import 'package:chat_application/services/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {

      if (FirebaseAuthProvider.firebaseAuth.currentUser != null) {

        Provider.of<ServiceProvider>(context,listen: false).fetchAllChatUsers();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainScreen()));

      } else {
      
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    mobileScreenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
        Gif(
          image: AssetImage("assets/gifs/chat.gif"),
          height: 500,
          width: mobileScreenSize.width,
          autostart: Autostart.once,
          fit: BoxFit.fill,
        ),
      SizedBox(height: 60,),
        const Text('Chat App',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87, letterSpacing: .5)),
      ]),
    );
  }
}
