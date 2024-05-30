import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';
import '../../screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: mobileScreenSize.width * .6,
          height: mobileScreenSize.height * .35,
          child: Stack(
            children: [

              Positioned(
                top: mobileScreenSize.height * .075,
                left: mobileScreenSize.width * .1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mobileScreenSize.height * .25),
                  child: CachedNetworkImage(
                    width: mobileScreenSize.width * .5,
                    height: mobileScreenSize.width * .5,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              Positioned(
                left: mobileScreenSize.width * .04,
                top: mobileScreenSize.height * .02,
                width: mobileScreenSize.width * .55,
                child: Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}
