import 'package:TMDB_Mobile/model/model.dart';

class Genre extends Model {
  int id;
  String name;

  Genre(this.id, this.name);

  @override
  Genre.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
