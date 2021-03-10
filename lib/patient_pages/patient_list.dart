import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class PatientList extends StatefulWidget {
  final String id;
  PatientList(this.id);

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
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
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("patient").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      //final docs=snapshot.data.doc();
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data.docs.map((DocumentSnapshot document) {
                          return ListTile(
                            title: Text(document.data()['username']),
                            subtitle: Text(document.data()['email']),
                          );
                        }).toList(),
                      );
                    }else{
                      return Material(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
