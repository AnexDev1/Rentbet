import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? title;

  const MapView({
    Key? key,
    this.latitude = 37.42796133580664,  // Default coordinates
    this.longitude = -122.085749655962,
    this.title = 'Property Location'
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = {
      Marker(
        markerId: const MarkerId('property'),
        position: LatLng(widget.latitude!, widget.longitude!),
        infoWindow: InfoWindow(title: widget.title),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude!, widget.longitude!),
            zoom: 15,
          ),
          markers: _markers,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}