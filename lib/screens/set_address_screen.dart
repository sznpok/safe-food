import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:save_food/utils/size_config.dart';
import '/models/address.dart';

class SetAddressScreen extends StatefulWidget {
  const SetAddressScreen({Key? key}) : super(key: key);

  @override
  _SetAddressScreenState createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen> {
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(-33.8688, 151.2093),
    zoom: 14.4746,
  );

  final markers = Set<Marker>();

  final Completer<GoogleMapController> _controller = Completer();
  MarkerId markerId = const MarkerId("POSITION");
  LocationData locationData = LocationData();

  @override
  void initState() {
    // setMarker();
    GeolocatorPlatform.instance
        .getCurrentPosition()
        .then((value) => markers.add(
              Marker(
                markerId: markerId,
                position: LatLng(value.latitude, value.longitude),
              ),
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (position) {
              setState(() {
                _kGooglePlex = position;
                markers.add(
                    Marker(markerId: markerId, position: _kGooglePlex.target));
              });
              getLocations();
            },
            onTap: (position) {
              setState(() {
                _kGooglePlex = CameraPosition(
                  target: position,
                  zoom: 14.4746,
                );
                markers.add(Marker(markerId: markerId, position: position));
              });
              getLocations();
            },
            onCameraIdle: () {
              getLocations();
            },
            markers: markers,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // height: 190,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * .7,
              height: SizeConfig.height * 10,
              // margin: EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: MaterialButton(
                  color: const Color(0xFFF15B28),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    print(locationData);
                    Navigator.of(context).pop(locationData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15),
                    child: Text(
                      'Set Address',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // void setMarker() async {
  //   var m = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(size: Size(12, 12)), );

  //   var ma = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(size: Size(12, 12)), 'assets/images/car-icon.png');
  // }

  getLocations() async {
    setState(() {
      locationData.lat = _kGooglePlex.target.latitude;
      locationData.lng = _kGooglePlex.target.longitude;
    });
  }
}
