import 'package:rodocalc/app/data/models/trip_model.dart';

class TripPhotos {
  int? id;
  int? tripId;
  Trip? trips;
  String? arquivo;
  String? createdAt;
  String? updatedAt;

  TripPhotos({
    this.id,
    this.tripId,
    this.trips,
    this.arquivo,
    this.createdAt,
    this.updatedAt,
  });

  TripPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    trips = json['trips'] != null ? Trip.fromJson(json['trips']) : null;
    arquivo = json['arquivo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip_id'] = tripId;
    if (trips != null) {
      data['trips'] = trips!.toJson();
    }
    data['arquivo'] = arquivo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
