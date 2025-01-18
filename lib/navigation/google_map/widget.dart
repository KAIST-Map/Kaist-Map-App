import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/constant/map.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:provider/provider.dart';

class KMapGoogleMap extends StatelessWidget {
  const KMapGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    final MapContext mapContext = context.watch<MapContext>();

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: KaistLocation.location,
        zoom: KaistLocation.zoom,
      ),
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          southwest: KaistLocation.southwestBound,
          northeast: KaistLocation.northeastBound,
        ),
      ),
      minMaxZoomPreference: const MinMaxZoomPreference(
        KaistLocation.minZoom,
        KaistLocation.maxZoom,
      ),
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        mapContext.setMapController(controller);
      },
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      compassEnabled: true,
      buildingsEnabled: true,
      trafficEnabled: false,
      indoorViewEnabled: false,
      style: '''[
        {
          "featureType": "poi",
          "elementType": "labels",
          "stylers": [
            {"visibility": "off"}
          ]
        },
        {
          "featureType": "poi.business",
          "elementType": "labels",
          "stylers": [
            {"visibility": "off"}
          ]
        }
      ]''',
      markers: mapContext.markers,
      onCameraMove: (position) => mapContext.setCameraPosition(position),
      onTap: mapContext.onTap,
    );
  }
}