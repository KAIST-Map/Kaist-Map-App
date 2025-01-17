import 'package:flutter/material.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/layout.dart';

void main() {
  runApp(const KMapMain());
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
          indicatorColor: primaryColor.shade700,
          surfaceTintColor: primaryColor.shade700,
          iconTheme: WidgetStateProperty.all(const IconThemeData(color: KMapColors.white)),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(color: KMapColors.white, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ),
      home: const Scaffold(
        body: KMapNavigation(),
      ),
    );
  }
}
