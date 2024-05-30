import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/services/providers/service_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';

import '../widgets/chat_page/message_card.dart';
import 'view_profile_screen.dart';

class ChatScreen extends StatefulWidget {


  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final _textController = TextEditingController();

  bool _isUploading = false;
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(builder: (_, serviceProvider, __) {
      return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(serviceProvider),
          ),

          backgroundColor: const Color.fromARGB(255, 234, 248, 255),

          
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: serviceProvider.isChatMessageLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : serviceProvider.allChatMessage.isEmpty
                            ? Center(
                                child: Text('Say Hii! 👋',
                                    style: TextStyle(fontSize: 16)),
                              )
                            : ListView.builder(
                                reverse: true,
                                itemCount: serviceProvider.allChatMessage.length,
                                padding: EdgeInsets.only(
                                    top: mobileScreenSize.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: serviceProvider.allChatMessage[index], currentUserId: serviceProvider.currentChatUser.id);
                                })),

                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2,color: Colors.green,))),

                _chatInput(serviceProvider),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _appBar(ServiceProvider serviceProvider) {
    return SafeArea(
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewProfileScreen(user: serviceProvider.selectedChatFrd)));
          },
          child: Row(
            children: [
              
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black54)),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(mobileScreenSize.height * .03),
                child: CachedNetworkImage(
                  imageUrl: serviceProvider.selectedChatFrd.image,
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
                  width: mobileScreenSize.height * .05,
                  height: mobileScreenSize.height * .05,
                ),
              ),

              const SizedBox(width: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(serviceProvider.selectedChatFrd.name,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500)),

                  
                  const SizedBox(height: 2),

                  
                  Text(serviceProvider.selectedChatFrd.isOnline?'Online':'Offline',
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              )
            ],
          )),
    );
  }

  
  Widget _chatInput(ServiceProvider serviceProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mobileScreenSize.height * .01,
          horizontal: mobileScreenSize.width * .025),
      child: Row(
        children: [
          
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  
                  IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),

                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        setState(() {
                          _isUploading=true;
                        });
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                         await serviceProvider.sendMediaMessage(File(i.path),'image' );
                        }
                        setState(() {
                          _isUploading=false;
                        });
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'mp4'],
                        );

                        if (result != null) {
                          String filePath = result.files.single.path!;
                          String filetype = filePath.contains('mp4')
                              ? 'video'
                              : 'pdf';

                          setState(() {
                            _isUploading = true;
                          });
                         await serviceProvider.sendMediaMessage(
                              File(filePath), filetype);

                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      child: const Icon(Icons.file_present,
                          color: Colors.blueAccent, size: 26)),


                  
                  SizedBox(width: mobileScreenSize.width * .02),
                ],
              ),
            ),
          ),

          
          MaterialButton(
            onPressed: ()async {
              if (_textController.text.isNotEmpty) {
              String msg=_textController.text;
              await serviceProvider.sendMessage( msg, 'text');
                _textController.text = '';
              }

            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
