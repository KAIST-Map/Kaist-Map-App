import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaist_map/constant/map.dart';
import 'package:kaist_map/navigation/kakao_map/core.dart';
import 'package:kaist_map/navigation/kakao_map/map_context.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapWidget extends StatefulWidget {
  const KakaoMapWidget({super.key});

  @override
  State<KakaoMapWidget> createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  final baseUrl = 'https://kaist-map.github.io/Kaist-Map-App';

  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    Permission.location.isGranted.then((granted) {
      if (!granted) {
        Permission.location.request().then((status) {
          setState(() {
            if (!status.isGranted) {
              SystemNavigator.pop();
            }
          });
        });
      }
    });

    final kakaoMapContext = context.watch<KakaoMapContext>();

    _controller ??= WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('$baseUrl/kakao_map.html'))
      ..addJavaScriptChannel("OnMapCreatedChannel",
          onMessageReceived: (message) {
        kakaoMapContext.controller = _controller;
        Future.delayed(const Duration(milliseconds: 300), () {
          kakaoMapContext.lookAt(KaistLocation.location);
        });
        kakaoMapContext.startMyLocationService();
      })
      ..addJavaScriptChannel("OnMarkerClickedChannel",
          onMessageReceived: (message) {
        final marker = kakaoMapContext.showingMarkers[kakaoMapContext.zoomLevel-1].firstWhere((marker) =>
            marker.name == jsonDecode(message.message)['name'].toString());
        marker.onTap();
        kakaoMapContext.lookAt(LatLng(marker.lat, marker.lng));
      })
      ..addJavaScriptChannel("OnMapClickedChannel",
          onMessageReceived: (message) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      })
      ..addJavaScriptChannel("OnZoomChangedChannel",
          onMessageReceived: (message) {
        final int zoomLevel = jsonDecode(message.message)['zoom'];
        kakaoMapContext.setZoomLevel(zoomLevel);
      });

    kakaoMapContext.controller?.runJavaScript('''
        setMarkers(${[
      ...kakaoMapContext.showingMarkers[kakaoMapContext.zoomLevel-1]
          .map((marker) => jsonEncode(marker.toJson())),
      if (kakaoMapContext.myLocationMarker != null)
        jsonEncode(kakaoMapContext.myLocationMarker!.toJson()),
    ]});
        setPolylines(${kakaoMapContext.polylines.map((polyline) => jsonEncode(polyline.toJson())).toList()});
      ''');

    return Stack(
      children: [
        WebViewWidget(
          controller: _controller!,
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton.small(
              onPressed: () {
                final myLocation = kakaoMapContext.myLocation;
                if (myLocation != null) {
                  kakaoMapContext.lookAt(myLocation);
                }
              },
              child: const Icon(Icons.my_location)),
        ),
      ],
    );
  }
}
