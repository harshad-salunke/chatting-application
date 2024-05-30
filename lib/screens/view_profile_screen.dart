import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/global/my_date_util.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(title: Text(widget.user.name)),

          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mobileScreenSize.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mobileScreenSize.width, height: mobileScreenSize.height * .03),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(mobileScreenSize.height * .1),
                    child: CachedNetworkImage(
                      width: mobileScreenSize.height * .2,
                      height: mobileScreenSize.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  SizedBox(height: mobileScreenSize.height * .03),

                  Text(widget.user.email,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),

                  SizedBox(height: mobileScreenSize.height * .02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text('Close Friend',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
