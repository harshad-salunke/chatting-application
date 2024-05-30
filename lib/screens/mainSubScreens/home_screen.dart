import 'dart:developer';

import 'package:chat_application/screens/chat_screen.dart';
import 'package:chat_application/services/providers/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import '../../widgets/home_page/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ChatUser> allChatUsers = [];


  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    bool isDataLoading=Provider.of<ServiceProvider>(context,listen: false).isAllChatUserLoading;

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      bool isDataLoading=Provider.of<ServiceProvider>(context,listen: false).isAllChatUserLoading;
      if(!isDataLoading){
        if (message.toString().contains('resumed')) {
          print('resume');
          Provider.of<ServiceProvider>(context,listen: false).updateActiveStatus(true);
        }else{
          print('pause');
          Provider.of<ServiceProvider>(context,listen: false).updateActiveStatus(false);
        }
      }


      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(builder: (_,serviceProvider,__){
      if(!_isSearching){
        allChatUsers.clear();
        allChatUsers.addAll(serviceProvider.allChatUsersList);
      }
      return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: PopScope(

          canPop: !_isSearching,
          onPopInvoked: (_) async {
            if (_isSearching) {
              setState(() => _isSearching = !_isSearching);
            } else {
              Navigator.of(context).pop();
            }
          },

          child: Scaffold(
            
            appBar: AppBar(
              leading: Container(
                margin: EdgeInsets.only(left: 3),
                child: Gif(
                  image:
                  AssetImage("assets/gifs/loading.gif"),
                  autostart: Autostart.loop,
                  height: 50,
                  width: 60,
                ),
              ),
              title: _isSearching
                  ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Search Name & Email ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                onChanged: (val) {

                  allChatUsers.clear();
                  for (var user in serviceProvider.allChatUsersList) {
                    if (user.name.toLowerCase().contains(val.toLowerCase()) ||
                        user.email.toLowerCase().contains(val.toLowerCase())) {
                      allChatUsers.add(user);
                    }
                  }
                  if(val.isEmpty || val==''){
                    allChatUsers.clear();

                    allChatUsers.addAll(serviceProvider.allChatUsersList);
                  }
                  setState(() {

                  });
                },
              )
                  : const Text('Personal chats',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),

              ],
            ),
            
            body: Container(
              child: serviceProvider.isAllChatUserLoading?
              Center(child: CircularProgressIndicator()):
                  allChatUsers.isEmpty?Center(
                    child: Text('No Connections Found!',
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  ):
              ListView.builder(
                  itemCount: allChatUsers.length,
                  padding: EdgeInsets.only(top: mobileScreenSize.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: mobileScreenSize.width * .04, vertical: 4),
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: (){

                            serviceProvider.setEmptyChatBox();

                            serviceProvider.setSelectedChatFrd(allChatUsers[index]);

                            serviceProvider.fetchAllChatMessages();

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                        },
                        child: ChatUserCard(
                            user: allChatUsers[index]),
                      ),
                    );
                  }),
            ),

          ),
        ),
      );
    },);
  }


}
