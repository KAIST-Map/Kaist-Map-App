import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/component/building_filter.dart';
import 'package:kaist_map/navigation/kakao_map/map_context.dart';
import 'package:kaist_map/navigation/layout.dart';
import 'package:kaist_map/navigation/routing/routing_context.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuildingCategoryFilterContext()),
        ChangeNotifierProvider(create: (_) => NavigationContext()),
        ChangeNotifierProvider(create: (_) => BuildingContext()),
        ChangeNotifierProvider(create: (_) => RoutingContext()),
        ChangeNotifierProvider(create: (_) => KakaoMapContext()),
      ],
      builder: (context, child) {
        return const KMapMain();
      }));
}

class KMapMain extends StatelessWidget {
  static double? height;
  static double? paddingBottom;
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
            backgroundColor: KMapColors.darkBlue,
            indicatorColor: KMapColors.lightBlue.withOpacity(0.2),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: KMapColors.white);
              }
              return const IconThemeData(color: KMapColors.darkGray);
            }),
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                    fontWeight: FontWeight.bold, color: KMapColors.white);
              }
              return const TextStyle(
                  fontWeight: FontWeight.normal, color: KMapColors.darkGray);
            }),
          ),
          iconTheme: const IconThemeData(color: KMapColors.white),
          searchBarTheme: SearchBarThemeData(
            backgroundColor: WidgetStateProperty.all(KMapColors.darkBlue),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20.0)),
            hintStyle: WidgetStatePropertyAll(
              TextStyle(color: KMapColors.white.shade300),
            ),
            textStyle: const WidgetStatePropertyAll(
              TextStyle(color: KMapColors.white),
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: KMapColors.darkBlue,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: KMapColors.darkBlue.shade100,
            selectedColor: KMapColors.darkBlue,
            secondarySelectedColor: KMapColors.lightBlue,
            brightness: Brightness.light,
            elevation: 3.0,
            pressElevation: 3.0,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              backgroundColor: WidgetStateProperty.all(KMapColors.white),
              foregroundColor: WidgetStateProperty.all(KMapColors.darkBlue),
              side: WidgetStateProperty.all(
                const BorderSide(
                  color: KMapColors.darkBlue,
                  width: 1.0,
                ),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          dividerTheme: DividerThemeData(
            color: KMapColors.darkGray.shade200,
            space: 0,
            thickness: 1,
          ),
          searchViewTheme: SearchViewThemeData(
            backgroundColor: KMapColors.darkBlue,
            headerHintStyle: TextStyle(color: KMapColors.white.shade300),
            headerTextStyle: const TextStyle(color: KMapColors.white),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: KMapColors.lightBlue,
            selectionColor: KMapColors.lightBlue.withAlpha(150),
          )),
      home: const Scaffold(
        body: KMapNavigation(),
      ),
    );
  }
}
