import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../models/store.dart';

class OSMStoreMap extends StatefulWidget {
  final List<Store> stores;

  const OSMStoreMap({super.key, required this.stores});

  @override
  State<OSMStoreMap> createState() => _OSMStoreMapState();
}

class _OSMStoreMapState extends State<OSMStoreMap> {
  final _mapController = MapController.withPosition(
    initPosition: GeoPoint(
      latitude: 47.4358055,
      longitude: 8.4737324,
    ),
  );

  // List<Marker> markers = []; // List to store markers
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // Add markers for stores on initial load
  //   _addStoreMarkers();
  // }
  //
  // void _addStoreMarkers() {
  //   for (var store in widget.stores) {
  //     markers.add(
  //       Marker(
  //         point: GeoPoint(latitude: store.latitude, longitude: store.longitude),
  //         builder: (context) => Icon(
  //           Icons.store, // Change icon as desired
  //           color: Colors.blue,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: _mapController,
      mapIsLoading: Container(
        color: Colors.grey[900],
        child: const Center(
          child: SpinKitChasingDots(
            size: 50,
            color: Colors.amberAccent,
          ),
        ),
      ),
      osmOption: OSMOption(
        userTrackingOption: const UserTrackingOption(
          enableTracking: true,
          unFollowUser: false,
        ),
        zoomOption: const ZoomOption(
          initZoom: 8,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 500,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 48,
            ),
          ),
        ),
        roadConfiguration: const RoadOption(
          roadColor: Colors.yellowAccent,
        ),
      ),
    );
  }
}
