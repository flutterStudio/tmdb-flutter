class SpokenLanguage {
  String iso6391;
  String name;

  SpokenLanguage({this.iso6391, this.name});

  @override
  SpokenLanguage.fromJson(Map<String, dynamic> json) {
    iso6391 = json['iso_639_1'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_639_1'] = this.iso6391;
    data['name'] = this.name;
    return data;
  }
}
