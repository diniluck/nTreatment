import 'package:flutter/material.dart';
import 'package:ntreatment/Entry/Doctor_login.dart';

import 'package:ntreatment/Entry/login_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionChip(
                            label: Text('For Human',
                                style: TextStyle(color: Color(0xffffffff),)
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            backgroundColor: Color(0xff8DC34D),
                            elevation: 15,
                          ),
                          SizedBox(width: 20),
                          ActionChip(
                            label: Text('For Animal',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            backgroundColor: Color(0xff8DC34D),
                            elevation: 15,
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorSigninScreen()));
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
      ),
    );
  }
}