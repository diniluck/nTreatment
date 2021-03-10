
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:ntreatment/Entry/dashboard.dart';
import 'package:ntreatment/Entry/registration_page.dart';



class DoctorSigninScreen extends StatefulWidget {
  @override
  _DoctorSigninScreenState createState() => _DoctorSigninScreenState();
}

class _DoctorSigninScreenState extends State<DoctorSigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _doctorIDTextEditingcontroller = TextEditingController();
  final TextEditingController _passwordTextEditingcontroller = TextEditingController();
  Future <void>loginDoctor()async{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _doctorIDTextEditingcontroller.text,
        password: _passwordTextEditingcontroller.text,
      );
      await Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardForAll(FirebaseAuth.instance.currentUser.uid)));
  }
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
          child: Container(
            height: _screenHeight,
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset("images/Doctor.jpg"),
                  height: 240.0,
                  width: 240.0,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Doctor",
                    style: TextStyle(
                        color: Color(0xff8DC34D),
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  width: _screenWidth*0.8,
                  child: Material(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _doctorIDTextEditingcontroller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.person,color: Color(0xff8DC34D),),
                                hintText: "Id"
                            ),
                            obscureText: false,
                            cursorColor: Color(0xff8DC34D),
                          ),
                          TextFormField(
                            enableSuggestions: false,
                            controller: _passwordTextEditingcontroller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.lock,color: Color(0xff8DC34D),),
                                hintText: "Password"
                            ),
                            obscureText: true,
                            cursorColor: Color(0xff8DC34D),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                RaisedButton(
                  onPressed: () {
                    _doctorIDTextEditingcontroller.text.isNotEmpty &&
                        _passwordTextEditingcontroller.text.isNotEmpty
                        ? loginDoctor()
                        : SimpleDialog(
                      title: Text("Insert your Id and password"),
                    );
                  },

                  color: Color(0xff8DC34D),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 4.0,
                  width: _screenHeight * 0.8,
                  color: Color(0xff8DC34D),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegistrationPage()));
                  },
                  icon: Icon(
                    Icons.nature_people,
                    color: Color(0xff8DC34D),
                  ),
                  label: Text(
                    "I'm Not Doctor",
                    style: TextStyle(
                      color: Color(0xff8DC34D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*class DoctorSigninScreen extends StatelessWidget {
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
        centerTitle: true,
      ),
      body: DoctorSignInPage(),
    );
  }
}

class DoctorSignInPage extends StatefulWidget {
  @override
  _DoctorSignInPageState createState() => _DoctorSignInPageState();
}

class _DoctorSignInPageState extends State<DoctorSignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _doctorIDTextEditingcontroller = TextEditingController();
  final TextEditingController _passwordTextEditingcontroller = TextEditingController();
  loginDoctor()async{
    if(_doctorIDTextEditingcontroller=="doctor@gmail.com" && _passwordTextEditingcontroller=="123456"){
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _doctorIDTextEditingcontroller.text,
        password: _passwordTextEditingcontroller.text,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardForAll(FirebaseAuth.instance.currentUser.uid)));
    }
  }
  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: _screenHeight,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset("images/Doctor.jpg"),
                height: 240.0,
                width: 240.0,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Doctor",
                  style: TextStyle(
                      color: Color(0xff8DC34D),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                width: _screenWidth*0.8,
                child: Material(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _doctorIDTextEditingcontroller,
                         decoration: InputDecoration(
                           border: InputBorder.none,
                           prefixIcon: Icon(Icons.person,color: Color(0xff8DC34D),),
                           hintText: "Id"
                         ),
                          obscureText: false,
                          cursorColor: Color(0xff8DC34D),
                        ),
                        TextFormField(
                          enableSuggestions: false,
                          controller: _passwordTextEditingcontroller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock,color: Color(0xff8DC34D),),
                              hintText: "Password"
                          ),
                          obscureText: true,
                          cursorColor: Color(0xff8DC34D),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25,),
              RaisedButton(
                onPressed: () {
                  _doctorIDTextEditingcontroller.text.isNotEmpty &&
                  _passwordTextEditingcontroller.text.isNotEmpty
                      ? loginDoctor()
                      : SimpleDialog(
                    title: Text("Insert your Id and password"),
                  );
                },

                color: Color(0xff8DC34D),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 4.0,
                width: _screenHeight * 0.8,
                color: Color(0xff8DC34D),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()));
                },
                icon: Icon(
                  Icons.nature_people,
                  color: Color(0xff8DC34D),
                ),
                label: Text(
                  "I'm Not Doctor",
                  style: TextStyle(
                    color: Color(0xff8DC34D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  *//*loginDoctor() {
    FirebaseFirestore.instance.collection("Doctor").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if(result.data()["id"] !=_doctorIDTextEditingcontroller.text.trim()){
          //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your id is not correct."),));
        }else if(result.data()["password"] !=_passwordTextEditingcontroller.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your password is incorrect"),));
        }else{
          //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin"+result.data()["name"]),));
          setState(() {
            _doctorIDTextEditingcontroller.text="";
            _passwordTextEditingcontroller.text="";
          });
          Route route=MaterialPageRoute(builder: (c)=>PatientList());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }*//*
}*/

