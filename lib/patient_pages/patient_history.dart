import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ntreatment/widget/patient_info_widget.dart';

class PatientHistory extends StatefulWidget {
  final String id;
  PatientHistory(this.id);
  @override
  _PatientHistoryState createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {
  Future myVideos;
  Stream myStream;
  int patientNumber = 0;
  List<String> patientList = [
    "patient no 1",
    "patient no 2",
    "patient no 3",
    "patient no 4",
    "patient no 5",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("patient").doc(FirebaseAuth.instance.currentUser.uid).collection("patientName").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("No data"),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs
                          .map(
                            (patientData) => PatientInfo(
                              PatientName: patientData.data()['PatientName'],
                              Age: patientData.data()['Age'],
                              DiseaseName: patientData.data()['DiseaseName'],
                              type: patientData.data()['type'],
                            ),
                          ).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
