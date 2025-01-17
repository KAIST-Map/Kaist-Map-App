import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:kaist_map/navigation/layout.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MapContext())],
      child: const KMapMain()));
}

class KMapMain extends StatelessWidget {
  const KMapMain({super.key});

  final MaterialColor primaryColor = KMapColors.darkBlue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor),
        fontFamily: 'Pretendard',
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: primaryColor.shade900,
          indicatorColor: KMapColors.lightBlue.shade100,
          iconTheme: WidgetStateProperty.all(
              const IconThemeData(color: KMapColors.white)),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(
              color: KMapColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500)),
        ),
      ),
      home: const Scaffold(
        body: KMapNavigation(),
      ),
    );
  }
}
