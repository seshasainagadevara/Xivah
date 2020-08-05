import 'package:mongo_dart/mongo_dart.dart';

class User {
  final String name, type, username;
  final num userId, cache_area;
  final Address address;
  final ULocation location;

  User(
      {this.name,
      this.type,
      this.username,
      this.userId,
      this.cache_area,
      this.address,
      this.location});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'username': username,
      'type': type,
      'regDate': Timestamp(),
      'location': location?.toJson() ?? <String, dynamic>{},
      'address': address?.toJson() ?? <String, dynamic>{},
      'orders': [],
      'cart': [],
      'cache_area': 1,
      'modified': Timestamp()
    };
  }
}

class Address {
  final String state, district, pincode, city, area;
  Address({this.state, this.district, this.pincode, this.city, this.area});
  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'pincode': pincode,
      'district': district,
      'city': city,
      'area': area
    };
  }
}

class ULocation {
  final String locationType;
  final num longitude, latitude;
  ULocation({this.locationType = 'Point', this.longitude, this.latitude});

  Map<String, dynamic> toJson() {
    return {
      'type': locationType,
      'coordinates': [longitude, latitude]
    };
  }
}
