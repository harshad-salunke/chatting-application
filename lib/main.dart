import 'package:chat_application/screens/splash_screen.dart';
import 'package:chat_application/services/providers/firebase_auth_handler.dart';
import 'package:chat_application/services/providers/service_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


late Size mobileScreenSize;


void main() async{
  await WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp();

  
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context)=>FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (context)=>ServiceProvider())

    ],child: MaterialApp(
        title: 'Chat app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
              backgroundColor: Colors.white,
            )),
        home: const SplashScreen()),);
  }
}


