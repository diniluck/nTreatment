import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPatientImages extends StatefulWidget {
  final File imageFile;
  final String imagePath;
  final ImageSource imageSource;

  UploadPatientImages(this.imageFile, this.imagePath, this.imageSource);
  @override
  _UploadPatientImagesState createState() => _UploadPatientImagesState();
}

class _UploadPatientImagesState extends State<UploadPatientImages> {
  TextEditingController captionsController = TextEditingController();
  File file;
  bool uploading=false;
  Future uploadImage()async{
    //final StorageReference storageReference = FirebaseStorage.instance.ref().child("patient");
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("patient").child('patientImage');
    StorageUploadTask uploadTask = storageReference.child("patientImage").putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl) {
    var cpatientIdforVideo = FirebaseAuth.instance.currentUser.uid;
    final itemsRef = FirebaseFirestore.instance
        .collection('patient')
        .doc(cpatientIdforVideo)
        .collection('patientImages');
    itemsRef.doc("patientImages").set({
      "Send at": DateTime.now(),
      "caption": captionsController,

      "thumbnailUrl": downloadUrl,


    });
    setState(() {
      //file=null;
      uploading=false;

    });
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
            },
            icon: Icon(Icons.logout),
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1.2,
            height: MediaQuery.of(context).size.height/4,
            child: Image.file(file),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            margin: EdgeInsets.only(right: 50),
            child: TextField(
              controller: captionsController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Captions',
                labelStyle: TextStyle(fontSize: 20),
                prefixIcon: Icon(Icons.closed_caption),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () {
                  uploadImage();
                },
                color: Colors.black,
                child: Text('Upload Video',
                    style: TextStyle(fontSize: 18,color: Colors.white)
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.redAccent,
                child: Text('Another Video',
                    style:  TextStyle(fontSize: 18,color: Colors.white)
                ),
              ),
            ],
          ),
          Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("patient").doc(FirebaseAuth.instance.currentUser.uid).collection("patientImages").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index){
                        DocumentSnapshot image=snapshot.data.docs[index];
                        return Container(
                          width: MediaQuery.of(context).size.width/3,
                          height: MediaQuery.of(context).size.height/4,
                          child: Image(
                            image: NetworkImage(image.data()['thumbnailUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
