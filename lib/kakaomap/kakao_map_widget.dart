import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapWidget extends StatefulWidget {
  const KakaoMapWidget({Key? key}) : super(key: key);

  @override
  State<KakaoMapWidget> createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  late final WebViewController _controller;

  static const url = "https://kaist-map.github.io/Kaist-Map-App/kakao_map.html";
  final apiKey = dotenv.env['KAKAO_API_KEY']!;
  static const initialLatitude = 37.5665;
  static const initialLongitude = 126.9780;
  static const initialLevel = 4;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (message) {
          print('Received message from Kakao Map: ${message.message}');
        },
      )
      ..loadRequest(Uri.parse(url))
      ..runJavaScript('''
        initializeMap("$apiKey", $initialLatitude, $initialLongitude, $initialLevel);
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
