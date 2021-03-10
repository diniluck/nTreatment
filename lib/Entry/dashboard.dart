
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntreatment/patient_pages/patient_dashboard.dart';
import 'package:ntreatment/patient_pages/patient_list.dart';


class DashBoardForAll extends StatefulWidget {
  String id = FirebaseAuth.instance.currentUser.uid;
  DashBoardForAll(this.id);
  @override
  _DashBoardForAllState createState() => _DashBoardForAllState();
}

class _DashBoardForAllState extends State<DashBoardForAll> {

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
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15.0,
                    spreadRadius: 0.0,
                    offset: Offset(4.0, 4.0), // shadow direction: bottom right
                  )
                ],
                border: Border.all(
                  color: Color(0xff8DC34D),
                  width: 4,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(50),
                  bottomRight: const Radius.circular(50),
                ),
              ),
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('images/logo.jpg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionChip(
                          label: Text(
                              'Patient Dashboard',
                              style: TextStyle(color: Color(0xffffffff),)
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDashboard(FirebaseAuth.instance.currentUser.uid)));
                          },
                          backgroundColor: Color(0xff8DC34D),
                          elevation: 15,
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Text(
                            "Here you can get all kinds of servicess. If you want."
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                          offset: Offset(4.0, 4.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Container(
                      width: _screenWidth*.8,
                      height: 120,
                      child: Column(
                        children: [
                          Text(
                            'Meet Dr. Patricia ("Patti") McCartney',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'What treatment do you want from Dr Patti for?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ), // child widget, replace with your own
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                          offset: Offset(4.0, 4.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Container(
                      width: _screenWidth*.8,
                      height: 120,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          FlatButton.icon(
                            onPressed: () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => PatientList()));
                              AccessDoctor();
                            },
                            icon: Icon(
                              Icons.nature_people,
                              size: 40,
                              color: Color(0xff8DC34D),
                            ),
                            label: Text(
                              "I'm Doctor",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), // child widget, replace with your own
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future <void> AccessDoctor()async{
    if(FirebaseAuth.instance.currentUser.email=='doctor@gmail.com'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => PatientList(FirebaseAuth.instance.currentUser.uid)));
    }else{
      SimpleDialog(
        title: Text('You are not Doctor'),
      );
    }
  }
}
