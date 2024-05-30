import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/permissions/main_permissions_helper.dart';
import '../models/map_screen_params.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.mapParams});
  final MapParams? mapParams;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  Position? currentLocation;
  LatLng? selectedPoint;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.mapParams == null) {
      _getCurrentLocation();
    } else {
      final params = widget.mapParams!;
      title = params.location;
      selectedPoint = LatLng(params.lat, params.lng);
    }
  }

  _getCurrentLocation() async {
    currentLocation = await MainPermissionHandler.requestLocationPermission();
    if (currentLocation != null) {
      selectedPoint = LatLng(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      markers.add(
        Marker(
          point: selectedPoint!,
          child: const Icon(Icons.location_on_outlined),
        ),
      );
      _mapController.move(selectedPoint!, 9);
      setState(() {});
    }
  }

  String? title;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(title ?? "Location"),
        ),
        leading: const BackButton(),
        actions: const [SizedBox(width: 20)],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: selectedPoint ?? const LatLng(50.5, 30.51),
          initialZoom: 9.2,
          minZoom: 5.2,
          maxZoom: 18.2,
          onTap: (tapPosition, point) {
            widget.mapParams?.onTap?.call(point.latitude, point.longitude);
            markers.clear();
            selectedPoint = point;
            markers.add(
              Marker(
                point: point,
                child: const Icon(Icons.location_on_outlined),
              ),
            );
          },
        ),
        children: [
          TileLayer(
            urlTemplate: urlTemplate,
          ),
          MarkerLayer(
            markers: markers,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  String get urlTemplate {
    return "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  }
}
