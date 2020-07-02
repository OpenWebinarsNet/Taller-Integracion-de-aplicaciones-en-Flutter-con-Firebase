import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/serie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SerieCard extends StatefulWidget {
  SerieCard({Key key, @required this.serie, @required this.onToDoChanged})
      : super(key: key);

  final Serie serie;
  final ValueChanged<Serie> onToDoChanged;
  _SerieCardState createState() => _SerieCardState();
}

class _SerieCardState extends State<SerieCard> {
  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 5,
      child: new Column(
        children: <Widget>[
          buildMainContent(),
          Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(widget.serie.isInToDo
                    ? Icons.turned_in
                    : Icons.turned_in_not),
                onPressed: () {
                  setState(() {
                    widget.serie.isInToDo = !widget.serie.isInToDo;
                    widget.onToDoChanged(widget.serie);
                  });
                },
              ))
        ],
      ),
    );
  }

  Widget buildMainContent() {
    if (widget.serie.posterPath != null && widget.serie.posterPath.isNotEmpty) {
      return buildCardWithPoster();
    } else {
      return new Text(
        widget.serie.name,
      );
    }
  }

  Widget buildCardWithPoster() {
    return new Row(
      children: <Widget>[
        // Image part
        Container(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl:
                widget.serie.posterPath,
                height: 250.0,
          ),
          ),
        ),
        // Details part
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            height: 250,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.serie.name,
                    maxLines: 3, style: TextStyle(fontSize: 20)),
                buildGenreButton(),
                Text(
                  "Vote: " + widget.serie.voteAverage.toString(),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    widget.serie.overview,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildGenreButton() {
    return new Container(
      child: new Text(widget.serie.genre,
          style: new TextStyle(color: Colors.white, fontSize: 12)),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.red),
      padding: new EdgeInsets.all(9),
      margin: new EdgeInsets.fromLTRB(0, 5, 0, 5),
    );
  }
}
