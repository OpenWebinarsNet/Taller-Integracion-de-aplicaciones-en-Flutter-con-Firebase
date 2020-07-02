import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/user/user_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Demo Home Page"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            // overflow menu
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Logout"),
                ),
              ],
              onSelected: (value) async {
                bool result = await UserController().signOut();
                if (result) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                        Navigator.of(context).pushNamed('/home/series_home');
                      },
                      child: Text(
                        "TV SHOWS",
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
            ),
          ),
        ));
  }
}
