class PlaceItem {
  String name;
  String address;
  double lat;
  double lng;
  PlaceItem(this.name, this.address, this.lat, this.lng);

  static List<PlaceItem> fromJson(Map<String, dynamic> json) {
    print("parse data");
    List<PlaceItem> rs = new List();

    var results = json['results'] as List;
    for (var item in results) {
      var p = new PlaceItem(
          item['name'],
          item['formatted_address'],
          item['geometry']['location']['lat'],
          item['geometry']['location']['lng']);

      rs.add(p);
    }

    return rs;
  }
}

class Distance {
  String test;
 // String distance_duration;
  /*String address;
  double lat;
  double lng;*/
  Distance(this.test);

  static List<Distance> fromJson(Map<String, dynamic> json) {
  //  print("parse data");
    List<Distance> rs = new List();

    var results = json['rows'] as List;
    for (var item in results) {
      var p = new Distance(

          item['elements']['distance']);

      rs.add(p);

    }
    //print("Element "+rs.toString());
    return rs;
  }
}
