import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home/home_page.dart';
import 'package:flutter_firebase/screens/home/loading_page.dart';
import 'package:flutter_firebase/screens/login/login_page.dart';
import 'package:flutter_firebase/screens/series/series_home.dart';
import 'package:flutter_firebase/services/user/user_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        // Set routes for using the Navigator.
        '/home': (BuildContext context) => new HomePage(),
        '/home/series_home': (BuildContext context) => new SeriesHomePage(),
        '/login': (BuildContext context) => new LoginPage()
      },
      debugShowCheckedModeBanner: false,
      initialRoute: "splash",
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("build");
    return FutureBuilder<FirebaseUser>(
      future: UserController().getUserAuthenticated(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        //
        if (snapshot.connectionState == ConnectionState.done) {
          // log error to console
          if (snapshot.error != null) {
            return Text(snapshot.error.toString());
          }
          return snapshot.hasData ? HomePage() : LoginPage();
        } else {
          return LoadingPage();
        }
      },
    );
  }
}
