import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntreatment/patient_pages/patient_history.dart';

class EditUserProfile extends StatefulWidget {
  final String id;
  EditUserProfile(this.id);
  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  var _types=['Human','Animal'];
  var _currentPatientType = 'Human';
  List data = List();
  TextEditingController usernameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();

 Future<void> _addData()async{
    if(usernameController.text.length <=0 && ageController.text.length <=0 && diseaseController.text.length<=0){
      return SimpleDialog(
        title: Text('Insert The field properly'),
      );
    }
    String cpatientuid = FirebaseAuth.instance.currentUser.uid;
    final collection = FirebaseFirestore.instance.collection("patient").doc(cpatientuid).collection("patientName");
    await collection.add({
      "type": _currentPatientType,
      "PatientName": usernameController.text,
      "Age": ageController.text,
      "DiseaseName": diseaseController.text,
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientHistory(FirebaseAuth.instance.currentUser.uid)));
    usernameController=null;
    ageController=null;
    diseaseController=null;

  }
  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){},
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Color(0xff8DC34D),
                child: Icon(Icons.add_a_photo_rounded,color: Colors.grey,size: _screenWidth*0.15,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Row(
                children: [
                  Text(
                    'Patient type:',
                    style: TextStyle(
                        color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 10,),
                  DropdownButton<String>(
                    items: _types.map((String dropDownStringItem){
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                          style: TextStyle(
                              color: Colors.blue
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected){
                      setState(() {
                        this._currentPatientType=newValueSelected;
                      });
                    },
                    value: _currentPatientType,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  fillColor: Color(0xff8DC34D),
                  filled: true,
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  labelStyle: TextStyle(
                      fontSize: 20
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  fillColor: Color(0xff8DC34D),
                  filled: true,
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.person),
                  labelStyle: TextStyle(
                      fontSize: 20
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: diseaseController,
                decoration: InputDecoration(
                  fillColor: Color(0xff8DC34D),
                  filled: true,
                  labelText: 'Disease name',
                  prefixIcon: Icon(Icons.person),
                  labelStyle: TextStyle(
                      fontSize: 20
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: (){
                _addData();
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xff8DC34D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text('Update Information',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
