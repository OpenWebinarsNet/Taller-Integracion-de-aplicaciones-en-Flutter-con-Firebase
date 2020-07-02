import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/serie.dart';
import 'package:flutter_firebase/services/series/series_api_controller.dart';
import 'package:flutter_firebase/services/series/series_controller.dart';
import '../../services/user/user_controller.dart';
import 'components/serie_saved_card.dart';

class SeriesSavedPage extends StatefulWidget {
  SeriesSavedPage({Key key}) : super(key: key);

  _SeriesSavedPageState createState() => _SeriesSavedPageState();
}

class _SeriesSavedPageState extends State<SeriesSavedPage> {
  String userId;

  @override
  void initState() {
    UserController().getUserUID().then((id) => setState(() => userId = id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(userId == null) return Container();
    return StreamBuilder(
      builder: (context, projectSnap) {
        //Nothing
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        }

        //Loading
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.blue),
                      strokeWidth: 5.0),
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            ),
          );
        }

        if (projectSnap.hasData && projectSnap.data.length > 0) {
          return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2),
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                Serie serie = projectSnap.data[index];
                return new SavedSerieCard(
                    serie: serie,
                    onToDoChanged: (Serie serie) {
                      setState(() {
                        SeriesController().addRemoveSerie(serie);
                      });
                    });
              });
        } else {
          // Not results
          return Container(
            child: Text("Not movies in to-do"),
          );
        }
      },
      stream: SeriesAPIController().savedSeriesFor(userId),
    );
  }
}
