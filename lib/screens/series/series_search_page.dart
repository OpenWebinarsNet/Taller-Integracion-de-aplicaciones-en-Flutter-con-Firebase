import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/serie.dart';
import 'package:flutter_firebase/services/series/series_api_controller.dart';
import 'package:flutter_firebase/services/series/series_controller.dart';

import 'components/serie_card.dart';


class SeriesSearchPage extends StatefulWidget {
  SeriesSearchPage({Key key}) : super(key: key);

  _SeriesSearchPageState createState() => _SeriesSearchPageState();
}

class _SeriesSearchPageState extends State<SeriesSearchPage>
    with AutomaticKeepAliveClientMixin<SeriesSearchPage> {
  @override
  bool get wantKeepAlive => true;

  List<Serie> searchSeries = new List<Serie>();
  String _query = "";

  // Build all the page
  @override
  Widget build(BuildContext context) {
    super.build(context); // need to call super method.
    return Column(children: <Widget>[
      // Search field
      Container(
        margin: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20),
        child: new Column(
          children: <Widget>[
            TextField(
                onSubmitted: (String str) {
                  search(str);
                },
                decoration: InputDecoration(
                  labelText: "TV Show Name",
                )),
          ],
        ),
      ),
      // List      
      buildSearchList(),    
    ]);
  }

  // Build the list
  Widget buildSearchList() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        //Nothing
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        }

        //Loading
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return SizedBox(
            child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 5.0),
            height: 50.0,
            width: 50.0,
          );
        }

        searchSeries = projectSnap.data;
        if (searchSeries.length > 0) {
          return 
          Expanded(
            child: ListView.builder(
              itemCount: searchSeries.length,
              itemBuilder: (context, index) {
                Serie serie = searchSeries[index];
                return new SerieCard(
                      serie: serie,
                      onToDoChanged: (Serie serie) async {
                        await SeriesController().addRemoveSerie(serie);
                      });          
              })
          );
                
        } else {
          // Not results
          if (_query.isNotEmpty) {
            return Container(
              child: Text("Not results found"),
            );
          } else {
            return Container();
          }
        }
      },
      future: SeriesAPIController().getSeries(_query),
    );
  }

  search(String query) {
    if (query.length > 3) {
      setState(() {
        _query = query;
      });
    }
  }
}
