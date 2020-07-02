import 'package:flutter_firebase/model/serie.dart';
import 'package:flutter_firebase/services/series/series_api_controller.dart';

class SeriesController {

  static final SeriesController _singleton =
      new SeriesController._constructor();

  factory SeriesController() {
    return _singleton;
  }

  SeriesController._constructor();

  Future addRemoveSerie(Serie serie) async {
    if (serie.isInToDo) {
      // we add it
      await SeriesAPIController().saveSerie(serie);
    } else {      
      await SeriesAPIController().removeSerie(serie.id.toString());
    }
  }

}
