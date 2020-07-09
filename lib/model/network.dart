import 'package:TMDB_Mobile/model/model.dart';

class Network extends Model {
  String name;
  int id;
  String logoPath;
  String originCountry;

  Network({this.name, this.id, this.logoPath, this.originCountry});

  @override
  Network.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    logoPath = json['logo_path'];
    originCountry = json['origin_country'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['logo_path'] = this.logoPath;
    data['origin_country'] = this.originCountry;
    return data;
  }
}