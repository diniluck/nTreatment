

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntreatment/Entry/login_page.dart';
import 'package:ntreatment/patient_pages/patient_dashboard.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  //String userImageUrl;
  //File _imageFile;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _emailErro;
  String _passwordErro;
  Future<void> _registerUser()async{
    if(emailController.text.length<1){
      setState(() {
        _emailErro="Enter a email address";
      });
      return;
    }
    if(!emailController.text.contains("@")){
      setState(() {
        _emailErro="Enter a valid Email";
      });
      return;
    }
    if(passwordController.text.length<6){
      setState(() {
        _passwordErro="Your password must be at least 6 character.";
      });
      return;
    }
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text).then((signedUser){
        FirebaseFirestore.instance.collection('patient').doc(signedUser.user.uid).set({
          'username': usernameController.text,
          'password':passwordController.text,
          'email':emailController.text,
          'uId':signedUser.user.uid,
          'role': "patient",
        });
      });
    }catch(e){

    }
    _emailErro= null;
    _passwordErro= null;
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientDashboard(FirebaseAuth.instance.currentUser.uid),));
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/logo.jpg'),
                ),
                Text(
                  'Telemedicine App',
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xff8DC34D),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Registration For Remote Treatment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8DC34D),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
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
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Color(0xff8DC34D),
                      filled: true,
                      labelText: 'Email',
                      errorText: _emailErro,
                      prefixIcon: Icon(Icons.mail),
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      fillColor: Color(0xff8DC34D),
                      filled: true,
                      labelText: 'Password',
                      errorText: _passwordErro,
                      prefixIcon: Icon(Icons.lock),
                      labelStyle: TextStyle(
                        fontSize: 20,
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
                    _registerUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff8DC34D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text('Register',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an Account?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(),));
                      },
                      child: Container(
                        height: 45,
                          width: 70,
                          child: Center(
                              child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff8DC34D),
                                  )
                              ),
                          ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
