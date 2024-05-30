import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/screens/splash_screen.dart';
import 'package:chat_application/services/providers/firebase_auth_handler.dart';
import 'package:chat_application/widgets/global/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../services/providers/service_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceProvider, FirebaseAuthProvider>(
      builder: (_, serviceProvider, firebaseProvider, __) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                headingWidget(serviceProvider),
                divider(),
                Expanded(
                  child: ListView(
                    children: [
                      logoutButton(firebaseProvider),
                      ExitButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget headingWidget(ServiceProvider serviceProvider) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: serviceProvider.currentChatUser.image,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  )),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(
              CupertinoIcons.person,
            )),
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Text("${serviceProvider.currentChatUser.name}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                )),
            Text("${serviceProvider.currentChatUser.email}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                )),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              width: 200,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.zero),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.edit_note,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      )
                    ],
                  )),
            )
          ],
        )
      ],
    );
  }

  Widget logoutButton(FirebaseAuthProvider firebaseAuthProvider) {
    return InkWell(
        onTap: () async {
          Dialogs.showProgressBarIcons(context, 'Please Wait');

          await firebaseAuthProvider.signOut();
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
          Dialogs.showSnackbar(context, 'LogOut Successfully..');
        },
        child: colorTile(Icons.logout, Colors.pink, "Logout"));
  }

  Widget ExitButton() {
    return InkWell(onTap: () {
      exit(0);
    }, child: bwTile(Icons.exit_to_app, "Exit"));
  }

  Widget bwTile(IconData icon, String text) {
    return colorTile(icon, Colors.black, text, blackAndWhite: true);
  }

  Widget colorTile(IconData icon, Color color, String text,
      {bool blackAndWhite = false}) {
    Color pickedColor = Colors.white;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(13)),
      margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: ListTile(
        leading: Container(
          child: Icon(icon, color: color),
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: blackAndWhite ? pickedColor : color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        title: Text(
          text,
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
      ),
    );
  }
}
