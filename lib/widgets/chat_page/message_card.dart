import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/models/chat_user.dart';
import 'package:chat_application/screens/pdf_screen.dart';
import 'package:chat_application/screens/video_player_screen.dart';
import 'package:chat_application/services/providers/service_provider.dart';
import 'package:chat_application/widgets/chat_page/option_Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:provider/provider.dart';

import '../global/dialogs.dart';
import '../global/my_date_util.dart';
import '../../models/message.dart';


class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message,required this.currentUserId});
 final String currentUserId;
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = widget.currentUserId == widget.message.fromId;
    return Consumer<ServiceProvider>(builder: (_,serviceProvider,__){
      serviceProvider=serviceProvider;
      return InkWell(
          onLongPress: () {
            _showBottomSheet(isMe,serviceProvider);
          },
          child: isMe ? _greenMessage() : _blueMessage(serviceProvider));
    });
  }

  Widget _blueMessage(ServiceProvider serviceProvider) {

    if (widget.message.read.isEmpty) {
      serviceProvider.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == 'image'
                ? mobileScreenSize.width * .03
                : mobileScreenSize.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mobileScreenSize.width * .04, vertical: mobileScreenSize.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: getTypeOfMessage(widget.message),
          ),
        ),

        
        Padding(
          padding: EdgeInsets.only(right: mobileScreenSize.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Row(
          children: [

            SizedBox(width: mobileScreenSize.width * .04),

            
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            
            const SizedBox(width: 2),

            
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == 'image'
                ? mobileScreenSize.width * .03
                : mobileScreenSize.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mobileScreenSize.width * .04, vertical: mobileScreenSize.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: getTypeOfMessage(widget.message),
          ),
        ),
      ],
    );
  }

  Widget getTypeOfMessage(Message message){
    switch(message.type){
      case 'text':
        return Text(
          message.msg,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        );
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: message.msg,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) =>
            const Icon(Icons.image, size: 70),
          ),
        );
      case 'video':
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayerScreen(vdUrl: message.msg,)));
          },
          child: Container(
            height: 200,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: Icon(Icons.slow_motion_video,size: 50,),
            ),

          ),
        );
      case 'pdf':
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFViewerFromUrl(url: message.msg)));
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                 Container(
                   height: 150,
                   width: 100,
                   child: PDF().fromUrl(
                    message.msg,
                    placeholder: (double progress) => Center(child: Text('$progress %')),
                    errorWidget: (dynamic error) => Center(child: Icon(Icons.picture_as_pdf_outlined,size: 30,)),

                   ),
                 ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf_rounded,size: 35,color: Colors.red,),
                    SizedBox(width: 10,),
                    Text('Document', style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ],
            ),
          ),
        );

      default:
        return Text('waitting for message',style: TextStyle(color: Colors.black26),);
    }

  }

  void _showBottomSheet(bool isMe,ServiceProvider serviceProvider) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mobileScreenSize.height * .015, horizontal: mobileScreenSize.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == 'image'?
              OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'We Chat')
                              .then((success) {
                            
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully Saved!');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }):Container(),

              
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mobileScreenSize.width * .04,
                  indent: mobileScreenSize.width * .04,
                ),

              
              if (widget.message.type == 'text' && isMe)
                OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      
                      Navigator.pop(context);

                      _showMessageUpdateDialog(serviceProvider);
                    }),

              
              if (isMe)
                OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      Navigator.pop(context);
                      Dialogs.showProgressBarIcons(context, 'Deleting');
                        await serviceProvider.deleteMessage(widget.message);
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, 'Deleted Successfuly..');

                    }),

              
              Divider(
                color: Colors.black54,
                endIndent: mobileScreenSize.width * .04,
                indent: mobileScreenSize.width * .04,
              ),

              
              OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),


              OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  void _showMessageUpdateDialog(ServiceProvider serviceProvider) {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 25,
                  ),
                  Text(' Update Message',style: TextStyle(fontSize: 18),)
                ],
              ),

              
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              actions: [
                
                MaterialButton(
                    onPressed: () {
                      
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                
                MaterialButton(
                    onPressed: () async {
                      Dialogs.showProgressBarIcons(context, 'Loading');
                     await serviceProvider.updateMessage(widget.message, updatedMsg);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }


}


