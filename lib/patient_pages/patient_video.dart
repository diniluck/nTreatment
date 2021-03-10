import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntreatment/Entry/home_page.dart';
import 'package:ntreatment/video/video_player.dart';
import 'package:ntreatment/video/videoplayeritem.dart';

class PatientVideo extends StatefulWidget {

  @override
  _PatientVideoState createState() => _PatientVideoState();
}

class _PatientVideoState extends State<PatientVideo> {
  var cpatientIdforVideo = FirebaseAuth.instance.currentUser.uid;
  Stream myStream;
  void initState() {
    super.initState();
    myStream = FirebaseFirestore.instance
        .collection('patient')
        .doc(cpatientIdforVideo)
        .collection('videos').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8DC34D), Color(0xffffffff)],
              begin: const FractionalOffset(0.0,0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.8, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Herb-N-Wellness",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              });
            },
            icon: Icon(Icons.logout),
          )
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: myStream,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return PageView.builder(
            itemCount: snapshot.data.docs.length,
            controller: PageController(initialPage: 0,viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index){
              DocumentSnapshot videos = snapshot.data.docs[index];
              return Container(
                child: VideoPlayerItem(videos.data()['videoUrl']),
              );
            },
          );
        },
      ),
    );
  }
}
