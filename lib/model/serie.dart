class Serie {
  String name;
  String posterPath;
  String backdropPath;
  bool isInToDo = false;
  int id;
  double voteAverage;
  String genre;
  String overview;

  Serie(
      {this.id,
      this.name,
      this.posterPath,
      this.backdropPath,
      this.isInToDo,
      this.voteAverage,
      this.genre,
      this.overview});

  factory Serie.fromMap(Map<String, dynamic> json) => new Serie(
      id: json["id"],
      name: json["name"],
      isInToDo: true,
      posterPath: json["posterPath"],
      backdropPath: json["backdropPath"],
      voteAverage: json["voteAverage"].toDouble(),
      genre: json["genre"],
      overview: json["overview"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "posterPath": posterPath,
        "backdropPath": backdropPath,
        "voteAverage": voteAverage,
        "genre": genre,
        "overview": overview
      };
}
