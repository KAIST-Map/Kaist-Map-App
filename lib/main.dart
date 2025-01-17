import 'package:flutter/material.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:kaist_map/navigation/layout.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuildingContext()),
        ChangeNotifierProvider(create: (_) => MapContext())
      ],
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
          backgroundColor: KMapColors.lightBlue.shade100,
          indicatorColor: KMapColors.lightBlue.shade200,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: KMapColors.darkBlue);
              }
              return const IconThemeData(color: KMapColors.darkGray);
            }
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(fontWeight: FontWeight.bold);
              }
              return const TextStyle(fontWeight: FontWeight.normal);
            }
          ),
        ),
      ),
      home: const Scaffold(
        body: KMapNavigation(),
      ),
    );
  }
}
