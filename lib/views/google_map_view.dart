import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hajj_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:hajj_app/utils/location_service.dart';
import 'package:hajj_app/utils/map_services.dart';
import 'package:hajj_app/widgets/custom_list_view.dart';
import 'package:hajj_app/widgets/custom_text_field_for_map.dart';

import 'package:uuid/uuid.dart';
import '../widgets/custom_text_field.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});
  static const String id = 'GoogleMapView';

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initalCameraPoistion;

  late MapServices mapServices;
  late TextEditingController textEditingController;
  late GoogleMapController googleMapController;
  String? sesstionToken;
  late Uuid uuid;
  Set<Marker> markers = {};

  List<PlaceModel> places = [];
  Set<Polyline> polyLines = {};

  late LatLng desintation;

  Timer? debounce;
  @override
  void initState() {
    mapServices = MapServices();
    uuid = const Uuid();
    textEditingController = TextEditingController();
    initalCameraPoistion = const CameraPosition(target: LatLng(0, 0));
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(const Duration(milliseconds: 100), () async {
        sesstionToken ??= uuid.v4();
        await mapServices.getPredictions(
            input: textEditingController.text,
            sesstionToken: sesstionToken!,
            places: places);
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     body :
     Stack(
      children: [
        SafeArea(
          child: GoogleMap(
            polylines: polyLines,
            markers: markers,
            onMapCreated: (controller) {
              googleMapController = controller;
              updateCurrentLocation();
            },
            zoomControlsEnabled: false,
            initialCameraPosition: initalCameraPoistion,
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              CustomTextFieldMap(
                textEditingController: textEditingController,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomListView(
                onPlaceSelect: (placeDetailsModel) async {
                  textEditingController.clear();
                  places.clear();

                  sesstionToken = null;
                  setState(() {});
                  desintation = LatLng(
                      placeDetailsModel.geometry!.location!.lat!,
                      placeDetailsModel.geometry!.location!.lng!);

                  var points =
                      await mapServices.getRouteData(desintation: desintation);
                  mapServices.displayRoute(points,
                      polyLines: polyLines,
                      googleMapController: googleMapController);
                  setState(() {});
                },
                places: places,
                mapServices: mapServices,
              )
            ],
          ),
        ),
      ],
    )
    );
  }

  void updateCurrentLocation() {
    try {
      mapServices.updateCurrentLocation(
          onUpdatecurrentLocation: () {
            setState(() {});
          },
          googleMapController: googleMapController,
          markers: markers);
    // ignore: unused_catch_clause
    } on LocationServiceException catch (e) {
      // TODO:
    // ignore: unused_catch_clause
    } on LocationPermissionException catch (e) {
      // TODO :
    } catch (e) {
      // TODO:
    }
  }
}
