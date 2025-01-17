import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapWidget extends StatefulWidget {
  const KakaoMapWidget({Key? key}) : super(key: key);

  @override
  State<KakaoMapWidget> createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  late final WebViewController _controller;

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
      ..loadFlutterAsset('assets/kakao_map.html');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
    
  }

  void _initializeMap() {
    final apiKey = dotenv.env['KAKAO_API_KEY']!;
    const initialLatitude = 37.5665;
    const initialLongitude = 126.9780;
    const initialLevel = 4;

    final script = '''
      initializeMap("$apiKey", $initialLatitude, $initialLongitude, $initialLevel);
    ''';

    _controller.runJavaScript(script);
  }
}
