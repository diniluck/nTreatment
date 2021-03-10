import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntreatment/Entry/home_page.dart';

import 'package:ntreatment/chat/chat_screen.dart';
import 'package:ntreatment/patient_images/upload_image.dart';

import 'package:ntreatment/patient_pages/edit_profile.dart';
import 'package:ntreatment/patient_pages/patient_history.dart';
import 'package:ntreatment/patient_pages/patient_video.dart';
import 'package:ntreatment/video/add_video.dart';

class PatientDashboard extends StatefulWidget {
  String id = FirebaseAuth.instance.currentUser.uid;
  PatientDashboard(this.id);
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionChip(
                    label: Text('Patient History', style: TextStyle(color: Colors.white)),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientHistory(FirebaseAuth.instance.currentUser.uid)));
                    },
                    backgroundColor: Color(0xff8DC34D),
                    elevation: 20,
                  ),

                  SizedBox(width:20),
                  ActionChip(
                    label: Text('Update History', style: TextStyle(color: Colors.white)),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditUserProfile(FirebaseAuth.instance.currentUser.uid)));

                    },
                    backgroundColor: Color(0xff8DC34D),
                    elevation: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Image(
              image: AssetImage('images/logo.jpg'),
            ),
            Container(
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(

                color: Color(0xff8DC34D),
                borderRadius: BorderRadius.circular(50),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Human',
                  style: TextStyle(fontSize: 20, color: Color(0xffffffff),fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Text(
                    'Aromatherapy for Humans',
                    style: TextStyle(fontSize: 20,color: Color(0xff8DC34D),fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15),
                    child: Text(
                      'Essential oils offer many benefits when safely used on human. Dr. McCartney is trained in human aromatherapy and is able to formulate a custom blend according to your animal\'s personal Wellness Protocol,',
                      style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionChip(
                          label: Text('Chat', style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(FirebaseAuth.instance.currentUser.uid)));
                          },
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 20,
                        ),
                        SizedBox(width:20),
                        ActionChip(
                          label: Text('Send Image', style: TextStyle(color: Colors.white)),
                          onPressed: ()=>takeImage(context),
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 20,
                        ),
                        SizedBox(width:20),
                        ActionChip(
                          label: Text('Send video', style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVideoPage(FirebaseAuth.instance.currentUser.uid)));
                            //showOptionsDialog();
                          },
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionChip(
                          label: Text('Voice Call', style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>IndexPage()));
                          },
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 20,
                        ),
                        ActionChip(
                          label: Text('images', style: TextStyle(color: Colors.white)),
                          onPressed: (){},
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 20,
                        ),

                        ActionChip(
                          label: Text('videos', style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientVideo()));
                          },
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 20,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  takeImage(mFileImage) {
    return showDialog(
        context: mFileImage,
        builder: (context){
          return SimpleDialog(
            title: Text(
              "Report/Patient Image",
              style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture With Camera",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: (){
                  pickImage(ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Select From Gallery",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: (){
                  pickImage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
            ],
          );
        }
    );
  }
  File file;
  bool uploading=false;
  Future pickImage(ImageSource src)async{
    //Navigator.pop(context);
    final file = await ImagePicker().getImage(source: src);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadPatientImages(
        File(file.path),file.path,src
    )));
  }
}
