import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntreatment/video/add_video.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ConfirmVideoPage extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  final ImageSource imageSource;
  ConfirmVideoPage(this.videoFile, this.videoPath, this.imageSource);
  @override
  _ConfirmVideoPageState createState() => _ConfirmVideoPageState();
}

class _ConfirmVideoPageState extends State<ConfirmVideoPage> {
  TextEditingController musicController = TextEditingController();
  TextEditingController captionsController = TextEditingController();
  VideoPlayerController controller;
  FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8DC34D),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8DC34D), Color(0xffffffff)],
              begin: const FractionalOffset(0.0, 0.0),
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
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
        centerTitle: true,
      ),
      body: isUploading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Uploading.....', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: VideoPlayer(controller),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: musicController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Video Name',
                              labelStyle: TextStyle(fontSize: 15),
                              prefixIcon: Icon(Icons.music_note),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: EdgeInsets.only(right: 50),
                          child: TextField(
                            controller: captionsController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Captions',
                              labelStyle: TextStyle(fontSize: 15),
                              prefixIcon: Icon(Icons.closed_caption),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          uploadVideo();
                        },
                        color: Colors.black,
                        child: Text(
                          'Upload Video',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddVideoPage(FirebaseAuth.instance.currentUser.uid)));
                        },
                        color: Colors.redAccent,
                        child: Text(
                          'Another Video',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  uploadVideo() async {
    setState(() {
      isUploading = true;
    });
    try {
      var cpatientIdforVideo = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patient')
          .doc(cpatientIdforVideo)
          .get();
      var allDocs = await FirebaseFirestore.instance
          .collection('patient')
          .doc(cpatientIdforVideo)
          .collection('videos')
          .get();
      int length = allDocs.docs.length;
      String video = await uploadVideoToStorage('Video $length');
      String previewImage = await uploadImageToStorage('Video $length');

      FirebaseFirestore.instance
          .collection('patient')
          .doc(cpatientIdforVideo)
          .collection('videos')
          .doc('Video $length')
          .set({
        'username': userDoc.data()['username'],
        'uId': cpatientIdforVideo,
        'id': 'Video $length',
        'songName': musicController.text,
        'caption': captionsController.text,
        'videoUrl': video,
        'previewImage': previewImage,
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  uploadVideoToStorage(String id) async {
    StorageUploadTask storageUploadTask =
        FirebaseStorage.instance.ref().child(id).putFile(await compressVideo());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadImageToStorage(String id) async {
    StorageUploadTask storageUploadTask = FirebaseStorage.instance
        .ref()
        .child(id)
        .putFile(await getPreviewImage());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  compressVideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videoFile;
    } else {
      final compressVideo = await flutterVideoCompress
          .compressVideo(widget.videoPath, quality: VideoQuality.MediumQuality);
      return File(compressVideo.path);
    }
  }

  getPreviewImage() async {
    final previewImage =
        await flutterVideoCompress.getThumbnailWithFile(widget.videoPath);
    return previewImage;
  }
}
