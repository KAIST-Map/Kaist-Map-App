import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/constant/map.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class KMapGoogleMap extends StatefulWidget {
  const KMapGoogleMap({super.key});

  @override
  State<KMapGoogleMap> createState() => _KMapGoogleMapState();
}

class _KMapGoogleMapState extends State<KMapGoogleMap> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  Widget build(BuildContext context) {
    Permission.location.isGranted.then((granted) {
      if (!granted) {
        Permission.location.request().then((status) {
          setState(() {
            _permissionStatus = status;
          });
        });
      } else {
        setState(() {
          _permissionStatus = PermissionStatus.granted;
        });
      }
    });

    final MapContext mapContext = context.watch<MapContext>();

    return Stack(
      children: [
        GoogleMap(
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
          myLocationEnabled: _permissionStatus == PermissionStatus.granted,
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
        ),
        if (_permissionStatus == PermissionStatus.granted)
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton.small(
                onPressed: () =>
                    Geolocator.getCurrentPosition().then((position) {
                      mapContext.mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                            LatLng(position.latitude, position.longitude)),
                      );
                    }),
                child: const Icon(Icons.my_location)),
          ),
      ],
    );
  }
}
