import 'dart:io';

import 'package:chat_application/models/chat_user.dart';
import 'package:chat_application/services/firebase_database_dao.dart';
import 'package:chat_application/services/providers/firebase_auth_handler.dart';
import 'package:flutter/foundation.dart';

import '../../models/message.dart';

class ServiceProvider extends ChangeNotifier {
  FirebaseDatabaseDao firebaseDatabaseDao = FirebaseDatabaseDao();

  List<ChatUser> allChatUsersList = [];
  bool isAllChatUserLoading = true;
 bool isFirstTime=true;
  List<Message> allChatMessage = [];
  bool isChatMessageLoading = false;

  ChatUser currentChatUser = ChatUser(
    image: '',
    name: '',
    createdAt: '',
    isOnline: true,
    id: '',
    email: '',
  );

  late ChatUser selectedChatFrd;

  void fetchAllChatUsers() {
    firebaseDatabaseDao.allChatUserStream.listen((chatusers) {
      isAllChatUserLoading = false;
      allChatUsersList.clear();
      for (ChatUser user in chatusers) {
        if (user.id == FirebaseAuthProvider.firebaseAuth.currentUser?.uid) {
          currentChatUser = user;
          if(isFirstTime){
            updateActiveStatus(true);
            isFirstTime=false;
          }
        } else {
          allChatUsersList.add(user);
        }
      }

      notifyListeners();
    });
    firebaseDatabaseDao.fetchAllChatUser();
  }



  void fetchAllChatMessages() {
    String conversationId = getConversationID(selectedChatFrd.id);
    String path = 'Chats/${conversationId}/messages/';

    firebaseDatabaseDao.databaseReference.child(path).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map;
        allChatMessage.clear();
        values.forEach((key, value) {
          allChatMessage
              .add(Message.fromJson(Map<String, dynamic>.from(value)));
        });
        allChatMessage.sort((a, b) => b.sent.compareTo(a.sent));
      }
      isChatMessageLoading = false;
      notifyListeners();
    }).onError((error) {
      print(error.toString());
    });
  }

  Future<void> sendMessage(String msg, String type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: selectedChatFrd.id,
        msgId: '',
        msg: msg,
        read: '',
        type: type,
        fromId: currentChatUser.id,
        sent: time);
    String conversationId = getConversationID(selectedChatFrd.id);
    await firebaseDatabaseDao.sendMessage(conversationId, message);
  }

  Future<void> sendMediaMessage(File file, String type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: selectedChatFrd.id,
        msgId: '',
        msg: '',
        read: '',
        type: type,
        fromId: currentChatUser.id,
        sent: time);

    String conversationId = getConversationID(selectedChatFrd.id);

    await firebaseDatabaseDao.sendMediaMessageData(
        conversationId, message, file);
  }

  Future<void> saveUserDetails(ChatUser chatUser) async {
    currentChatUser = await firebaseDatabaseDao.saveUserDetails(chatUser);
  }

  Future<void> updateActiveStatus(bool activeStatus) async {
    firebaseDatabaseDao.updateActiveStatusData(currentChatUser, activeStatus);
    notifyListeners();
  }

  Future<void> updateMessageReadStatus(Message msg) async {
    String conversationId = getConversationID(selectedChatFrd.id);
    firebaseDatabaseDao.updateMessageReadStatus(
        conversationId, msg);
  }

  Future<void> updateMessage(Message message,String updateMsg) async {
    String conversationId = getConversationID(selectedChatFrd.id);
    firebaseDatabaseDao.updateMessageData(
        conversationId, message,updateMsg);
  }

  Future<void> deleteMessage(Message message)async{
    String conversationId = getConversationID(selectedChatFrd.id);

   await firebaseDatabaseDao.deleteMessageData(conversationId,message);
  }

  void setEmptyChatBox() {
    isChatMessageLoading = true;
    allChatMessage.clear();
    notifyListeners();
  }

  void setSelectedChatFrd(ChatUser chatUser) {
    selectedChatFrd = chatUser;
    notifyListeners();
  }

  String getConversationID(String id) =>
      currentChatUser.id.hashCode <= id.hashCode
          ? '${currentChatUser.id}_$id'
          : '${id}_${currentChatUser.id}';

  Future<bool> isUserExist(ChatUser chatUser) async {
    return await firebaseDatabaseDao.isUserExist(chatUser.id);
  }
}
