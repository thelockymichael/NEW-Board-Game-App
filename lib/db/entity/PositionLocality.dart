import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'message.dart';

class PositionLocality {
  late Position position;
  late Placemark placemark;

  PositionLocality(this.position, this.placemark);

  PositionLocality.fromSnapshot(DocumentSnapshot snapshot) {
    position = snapshot['position'];
    placemark = snapshot['placemark'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'position': position,
      'placemark': placemark,
    };
  }
}
