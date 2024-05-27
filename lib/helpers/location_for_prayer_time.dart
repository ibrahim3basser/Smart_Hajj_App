// import 'dart:html';

// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// class LocationPrayer{
// Future<bool> requestLocationPermission() async {
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }
//   return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
// }


// Future<Coordinates?> getUserLocation() async {
//   bool hasPermission = await requestLocationPermission();
//   if (hasPermission) {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       return Coordinates(latitude: position.latitude, longitude: position.longitude);
//     } on PlatformException catch (e) {
//       // Handle exceptions (e.g., permission denied, location services disabled)
//       print('Error getting location: $e');
//       return null;
//     }
//   } else {
//     return null; // User denied permission
//   }
// }
// }