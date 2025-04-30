class MyLocation {
  final String longitude;
  final String latitude; 
  MyLocation({required this.longitude, required this.latitude});

 factory MyLocation.fromMap(Map<String, dynamic> data) {
    return MyLocation(
      longitude: data['longitude'] ?? '',
      latitude: data['latitude'] ?? '',
    );}
}