import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/config/constants.dart';
import 'package:flutter_firebase/model/serie.dart';
import 'package:flutter_firebase/services/user/user_controller.dart';
import 'package:http/http.dart' as http;

class SeriesAPIController {
  dynamic getGenres() async {
    //to do: init beginning app instead of everytime doing a call -> it is not changing often
    var genreResponse = await http.get(
        "https://api.themoviedb.org/3/genre/tv/list?api_key=" +
            Constants.IMDB_API_KEY +
            "&language=en-US");
    Map<String, dynamic> parsedGenreJson = json.decode(genreResponse.body);
    return parsedGenreJson["genres"];
  }

  Future<List<Serie>> getSeries(String name) async {
    if (name == "") return new List<Serie>();
    String fixSearchUrl = "https://api.themoviedb.org/3/search/tv?";
    String apiKeyUrl = "api_key=" + Constants.IMDB_API_KEY;
    String parametersSearchUrl = "&language=en-US&query=" + name + "&page=1";
    String fullUrl = fixSearchUrl + apiKeyUrl + parametersSearchUrl;

    var response = await http.get(fullUrl);
    var genres = await getGenres();

    //Parsing results
    Map<String, dynamic> parsedJson = json.decode(response.body);
    List results = parsedJson["results"];
    var series = new List<Serie>();
    var partialImageUrl = "https://image.tmdb.org/t/p/w500";
    for (Map result in results) {
      String serieName = result["original_name"];
      String posterPath = result["poster_path"];
      String backPath = result["backdrop_path"];
      int id = result["id"];
      double voteAverage = result["vote_average"].toDouble();
      String overview = result["overview"];

      // Genre
      List<int> genreIds = result["genre_ids"].cast<int>();
      String genreName = "";
      if (genreIds.length > 0) {
        int genreId = genreIds[0];

        for (Map item in genres) {
          if (item["id"] == genreId) {
            genreName = item["name"];
          }
        }
      }

      var serie = new Serie();
      serie.id = id;
      serie.name = serieName;
      serie.posterPath =
          posterPath != null ? (partialImageUrl + posterPath) : "";
      serie.backdropPath = backPath != null ? (partialImageUrl + backPath) : "";
      serie.isInToDo = await isSerieAdded(serie.id);
      serie.voteAverage = voteAverage;
      serie.genre = genreName;
      serie.overview = overview;
      if (serie.posterPath.isNotEmpty) {
        series.add(serie);
      }
    }
    return series;
  }

  saveSerie(Serie serie) async {
    String userUid = await UserController().getUserUID();
    var series = Firestore.instance.collection("users/" + userUid + "/series");
    series.document(serie.id.toString()).setData(serie.toMap());
  }

  removeSerie(String id) async {
    String userUid = await UserController().getUserUID();
    var series = Firestore.instance.collection("users/" + userUid + "/series");
    series.document(id).delete();
  }

  Future<List<Serie>> getSavedSeries() async {
    String userUid = await UserController().getUserUID();
    var snap = await Firestore.instance
        .collection("users/" + userUid + "/series")
        .getDocuments();
    var series = new List<Serie>();

    for (var doc in snap.documents) {
      series.add(Serie.fromMap(doc.data));
    }
    return series;
  }

  Stream<List<Serie>> savedSeriesFor(String userId) {
    var snap = Firestore.instance
        .collection("users/" + userId + "/series")
        .snapshots();
    return snap.map((snapshot) =>
        snapshot.documents.map((doc) => Serie.fromMap(doc.data)).toList());
  }

  Future<bool> isSerieAdded(int id) async {
    String userUid = await UserController().getUserUID();
    final snapShot = await Firestore.instance
        .collection("users/" + userUid + "/series")
        .document(id.toString())
        .get();
    return (snapShot == null || !snapShot.exists) ? false : true;
  }
}
