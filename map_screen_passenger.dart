import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreenPassenger extends StatefulWidget {
  const MapScreenPassenger({super.key});

  @override
  State<MapScreenPassenger> createState() => _MapScreenPassengerState();}

class _MapScreenPassengerState  extends State<MapScreenPassenger> 
{
  final MapController _mapController = MapController();
  final Location _locationService = Location();
  Future<LocationData?> _getCurrentLocation() async {
      bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return null;
    }

    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    final locationData = await _locationService.getLocation();
    return locationData;
  }
  Future<void> _userCurrentLocation() async {
    final locationData = await _getCurrentLocation();
    if (locationData!=null){
    if (locationData.latitude != null && locationData.longitude != null) {
      final userLatLng = LatLng(locationData.latitude!, locationData.longitude!);
      _mapController.move(userLatLng, 15);
    }}
  }
 @override
Widget build(BuildContext context) {
  return Scaffold(
    body : ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 10,
              minZoom: 3,
              maxZoom: 30,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              CurrentLocationLayer(
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(Icons.location_pin, color: Colors.white),
                  ),
                  markerSize: Size(40, 40),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _userCurrentLocation,
              backgroundColor: Colors.teal,
              child: Icon(Icons.my_location, size: 30, color: Colors.white),
            ),
          ),
        ],
      ),
      ),
);
}
}