import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/widgets/home_page/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';

class ChatUserCard extends StatelessWidget {
  ChatUser user;
  ChatUserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => ProfileDialog(user: user));
        },
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(mobileScreenSize.height * .03),
          child: CachedNetworkImage(
            imageUrl: user.image,
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
            width: mobileScreenSize.height * .055,
            height: mobileScreenSize.height * .055,
          ),
        ),
      ),
      title: Text(
        user.name,
      ),
      subtitle: Text(
        user.isOnline ? 'Online' : 'Offline',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: user.isOnline ? Colors.green : Colors.red),
      ),
    );
  }
}
