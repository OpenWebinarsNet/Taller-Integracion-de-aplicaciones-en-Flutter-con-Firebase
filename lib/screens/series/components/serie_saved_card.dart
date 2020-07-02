import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/serie.dart';

class SavedSerieCard extends StatefulWidget {
  SavedSerieCard({Key key, @required this.serie, @required this.onToDoChanged})
      : super(key: key);

  final Serie serie;
  final ValueChanged<Serie> onToDoChanged;
  _SavedSerieCardState createState() => _SavedSerieCardState();
}

class _SavedSerieCardState extends State<SavedSerieCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: widget.serie.posterPath,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.turned_in),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          widget.serie.isInToDo = !widget.serie.isInToDo;
                          widget.onToDoChanged(widget.serie);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ]);
  }
}
