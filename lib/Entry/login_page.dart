
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntreatment/Entry/dashboard.dart';
import 'package:ntreatment/Entry/registration_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _emailError;
  String _passwordError;
  Future<void> _loginUser()async{
    if(emailController.text.length<1){
      setState(() {
        _emailError="Enter a email address";
      });
      return;
    }
    if(!emailController.text.contains("@")){
      setState(() {
        _emailError="Enter a valid Email";
      });
      return;
    }
    if(passwordController.text.length<6){
      setState(() {
        _passwordError="Your password must be at least 6 character.";
      });
      return;
    }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardForAll(FirebaseAuth.instance.currentUser.uid)));
    }catch(e){
      print(e);
    }
    _emailError= null;
    _passwordError= null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
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
                  'Login For Remote Treatment',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Color(0xff8DC34D),
                      filled: true,
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Color(0xffffffff),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
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
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      fillColor: Color(0xff8DC34D),
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xffffffff),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _loginUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff8DC34D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont have an Account?',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage(),));
                      },
                      child: Container(
                        height: 45,
                        width: 80,
                        child: Center(
                          child: Text('Register',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
