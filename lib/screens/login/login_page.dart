import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            color: Colors.white,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Logo
                Container(
                    child: Image.asset("assets/images/flutter_madrid.jpeg"),
                    padding: EdgeInsets.only(top: 150, left: 30, right: 30)),
                // Form: user y pwd
                Container(
                  margin:
                      EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20),
                  child: new Column(
                    children: <Widget>[
                      TextField(
                          autocorrect: false,
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: "User",
                              icon: Icon(Icons.account_circle))),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password", icon: Icon(Icons.lock)),
                      )
                    ],
                  ),
                ),
                // Login button
                Container(
                    padding: EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(20.0),
                      splashColor: Colors.blue,
                      onPressed: () {
                        _signInWithEmailAndPassword();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                    )),
              ],
            )));
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user;
    try {
      user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
    } catch (e) {}

    if (user != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login Error"),
      content: Text("Verify the input data"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
