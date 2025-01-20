import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  final baseUrl = 'http://10.0.2.2:8000';

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
        onMessageReceived: (message) => {
              kakaoMapContext.controller = _controller,
              kakaoMapContext.lookAt(KaistLocation.location),
            })
      ..addJavaScriptChannel("OnMarkerClickedChannel",
        onMessageReceived: (message) {
          final marker = kakaoMapContext.markers
              .firstWhere((marker) => marker.name == "\"${jsonDecode(message.message)['name']}\"");
          marker.onTap();
        })
      ..addJavaScriptChannel("OnMapClickedChannel",
        onMessageReceived: (message) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });


    kakaoMapContext.controller?.runJavaScript('''
      setMarkers(${kakaoMapContext.markers.map((marker) => marker.toJson()).toList()});
      setPolylines(${kakaoMapContext.polylines.map((polyline) => polyline.toJson()).toList()});
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
              onPressed: () => Geolocator.getCurrentPosition().then((position) {
                    kakaoMapContext
                        .lookAt(LatLng(position.latitude, position.longitude));
                  }),
              child: const Icon(Icons.my_location)),
        ),
      ],
    );
  }
}
