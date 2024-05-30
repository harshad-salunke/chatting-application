import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_application/models/chat_user.dart';
import 'package:chat_application/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
class FirebaseDatabaseDao{
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
   FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseAuth firebaseAuth=FirebaseAuth.instance;

 StreamController<ChatUser> _userController = StreamController<ChatUser>.broadcast();
 Stream<ChatUser> get userStream => _userController.stream;

  StreamController<List<ChatUser>> _allChatUserController = StreamController<List<ChatUser>>.broadcast();
  Stream<List<ChatUser>> get allChatUserStream => _allChatUserController.stream;


  Future<String> uploadImageToStorage(File file,String path,String type) async {
    final ext = file.path.split('.').last;
    final ref = storage
        .ref()
        .child('${path}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: '${type}/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

 void  fetchUserDetails() {
   String current_user_uid=firebaseAuth.currentUser!.uid;
   databaseReference.child('Users').child(current_user_uid).onValue.listen((event) {
     if (event.snapshot.value != null) {
       Map values = event.snapshot.value as Map;
       ChatUser userModel=ChatUser.fromJson(Map<String, dynamic>.from(values));
       _userController.add(userModel);
     }

   }).onError((error){
     print(error.toString());
   });

 }

  void  fetchAllChatUser() {
    databaseReference.child('Users').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map;
        List<ChatUser> chatUsersList = [];

        values.forEach((key, value) {

          chatUsersList.add(ChatUser.fromJson(Map<String, dynamic>.from(value)));
        });


        _allChatUserController.add(chatUsersList);
      }else{
        _allChatUserController.add([]);
      }
    }).onError((error){
      print(error.toString());
    });

  }


Future<void> sendMessage(String conversationId,Message msg)async{

   String path='Chats/${conversationId}/messages/';
   String pushKey=databaseReference.push().key!;
   msg.msgId=pushKey;
   Map<String, dynamic> data = msg.toJson();
   await databaseReference.child(path).child(pushKey).set(data);
}

  Future<void> sendMediaMessageData(String conversationId,Message message, File file) async{
    String imageUrl=await uploadImageToStorage(file, conversationId,message.type);
    message.msg=imageUrl;
    await sendMessage(conversationId,message);
  }


  Future<ChatUser> saveUserDetails(ChatUser chatUser) async {
   chatUser.createdAt=DateTime.now().microsecondsSinceEpoch.toString();

   Map<String, dynamic> data = chatUser.toJson();

   String path = 'Users/${chatUser.id}';

   await databaseReference.child(path).set(data);
   return chatUser;
 }

 Future<bool> isUserExist(String userId) async {

   DataSnapshot snapshot = await databaseReference.child('Users').child(userId).get();

   return snapshot.exists;

 }


   Future<void> updateMessageReadStatus(String conversationId,Message message) async {
     String path='Chats/${conversationId}/messages/${message.msgId}/';
     databaseReference.child(path)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future<void> updateMessageData(String conversationId,Message message,String updateMsg) async {
    String path='Chats/${conversationId}/messages/${message.msgId}/';
   print('path');
    databaseReference.child(path)
        .update({'msg':updateMsg });
  }

  void updateActiveStatusData(ChatUser currentChatUser, bool activeStatus) {
    String path = 'Users/${currentChatUser.id}';
    databaseReference.child(path)
        .update({'is_online': activeStatus});

  }

  Future<void> deleteMessageData(String conversationId,Message message,)async{
    String path='Chats/${conversationId}/messages';
    await databaseReference.child(path).child(message.msgId).remove();
  }




}