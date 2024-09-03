import '/models/direction.dart';
import '/utils/directions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    this.requireAppBar = true,
    required this.latitude,
    required this.longitude,
    required this.title,
  }) : super(key: key);

  final bool requireAppBar;
  final double latitude;
  final double longitude;
  final String title;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _googleMapController;
  Marker? _userMarker;
  late Marker _foodDonorMarker;
  Position? myPosition;
  Directions? _directions;
  late LatLng positionCenter;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    getLocation();

    _initialCameraPosition = const CameraPosition(
      target: LatLng(27.7172, 85.3240),
      zoom: 12.5,
    );
    positionCenter = LatLng(
      widget.latitude,
      widget.longitude,
    );
    _foodDonorMarker = Marker(
      markerId: MarkerId(widget.title),
      infoWindow: InfoWindow(title: widget.title),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: positionCenter,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  void getLocation() async {
    myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    final positionUser = LatLng(
      myPosition!.latitude,
      myPosition!.longitude,
    );
    setState(() {
      _userMarker = Marker(
        markerId: const MarkerId('User'),
        infoWindow: const InfoWindow(title: 'User'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: positionUser,
      );
    });
    final directions =
        await MyDirections().fetchDirection(positionUser, positionCenter);
    setState(() {
      _directions = directions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.requireAppBar
          ? AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text("Route"),
            )
          : null,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_userMarker != null) _userMarker!,
              _foodDonorMarker,
            },
            polylines: {
              if (_directions != null)
                Polyline(
                  polylineId: const PolylineId(
                    'navigation_polyline',
                  ),
                  color: Theme.of(context).primaryColor,
                  width: 5,
                  points: _directions!.polylinePoints
                      .map(
                        (p) => LatLng(
                          p.latitude,
                          p.longitude,
                        ),
                      )
                      .toList(),
                )
            },
          ),
          if (_directions != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  double.parse(_directions!.totalDistance) > 1000
                      ? '${(double.parse(_directions!.totalDistance) / 1000).toStringAsFixed(2)} Kms'
                      : '${_directions!.totalDistance} metres',
                  // '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () async {
          setState(
            () => _isUpdating = !_isUpdating,
          );
          myPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation);
          final positionUser = LatLng(
            myPosition!.latitude,
            myPosition!.longitude,
          );
          CameraPosition position =
              CameraPosition(target: positionUser, zoom: 11);
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(position),
          );
          final directions =
              await MyDirections().fetchDirection(positionUser, positionCenter);
          setState(() {
            _userMarker = Marker(
              markerId: MarkerId('User'),
              infoWindow: InfoWindow(title: 'User'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: positionUser,
            );
            _directions = directions;
            _isUpdating = !_isUpdating;
          });
        },
        child: _isUpdating
            ? CircularProgressIndicator()
            : Icon(Icons.center_focus_strong),
      ),
    );
  }
}
