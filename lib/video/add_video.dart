import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntreatment/video/confirm_video_page.dart';


class AddVideoPage extends StatefulWidget {
  String id = FirebaseAuth.instance.currentUser.uid;
  AddVideoPage(this.id);
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  showOptionsDialog(){
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: Text(
              "Take video from"
            ),
            children: [
              SimpleDialogOption(
                onPressed: (){
                  pickVideo(ImageSource.gallery);
                },
                child: Text('Gallery',style: TextStyle(fontSize: 20)),
              ),
              SimpleDialogOption(
                onPressed: (){
                  pickVideo(ImageSource.camera);
                },
                child: Text('Camera',style: TextStyle(fontSize: 20)),
              ),
              SimpleDialogOption(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Cancel',style: TextStyle(fontSize: 20)),
              ),
            ],
          );
        }
    );
  }
  pickVideo(ImageSource src)async{
    Navigator.pop(context);
    final video = await ImagePicker().getVideo(source: src);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmVideoPage(
        File(video.path),video.path,src
    )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8DC34D),
      body: InkWell(
        onTap: (){
          showOptionsDialog();
        },
        child: Center(
          child: Container(
            width: 180, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'Insert Video',
                style: TextStyle(fontSize: 20,color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
