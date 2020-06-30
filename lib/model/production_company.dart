import 'package:TMDB_Mobile/model/model.dart';

class ProductionCompany extends Model {
  int id;
  String logoPath;
  String name;
  String originCountry;

  ProductionCompany({this.id, this.logoPath, this.name, this.originCountry});

  @override
  ProductionCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoPath = json['logo_path'];
    name = json['name'];
    originCountry = json['origin_country'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo_path'] = this.logoPath;
    data['name'] = this.name;
    data['origin_country'] = this.originCountry;
    return data;
  }
}
