import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class MyProgressDialog extends StatelessWidget {
  String text;
   MyProgressDialog({required this.text}) ;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,

      child: Container(
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            Gif(
              image:
              AssetImage("assets/gifs/loading.gif"),
              autostart: Autostart.loop,
              height: 55,

            ),
            SizedBox(width: 0,),
            Text(
              '${text} . .',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
