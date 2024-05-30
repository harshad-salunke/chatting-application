import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';

import '../../services/providers/service_provider.dart';
class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {


  bool _isSearching = false;



  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(builder: (_,serviceProvider,__){
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

                },
              )
                  : const Text('Groups chats',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
              child: Center(
                child: Text('No Groups Found!',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
              ),
            ),
            floatingActionButton: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(

                  backgroundColor:Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (){
                },
                child: Container(
                  width: 115,
                  child: Row(
                    children: [
                      Icon(Icons.add_box_rounded,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Create Group',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          ),
        ),
      );
    },);
  }
}
