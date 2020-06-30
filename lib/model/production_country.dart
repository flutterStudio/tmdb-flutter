import 'package:TMDB_Mobile/model/model.dart';

class ProductionCountry extends Model {
  String iso31661;
  String name;

  ProductionCountry({this.iso31661, this.name});

  @override
  ProductionCountry.fromJson(Map<String, dynamic> json) {
    iso31661 = json['iso_3166_1'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_3166_1'] = this.iso31661;
    data['name'] = this.name;
    return data;
  }
}
