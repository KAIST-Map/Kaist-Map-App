import 'package:flutter/material.dart';

class KaistColors {
  static const Color darkBlue = Color.fromRGBO(0, 65, 145, 1);
  static const Color mediumBlue = Color.fromRGBO(0, 65, 135, 1);
  static const Color blue = Color.fromRGBO(20, 135, 200, 1);
  static const Color lightBlue = Color.fromRGBO(95, 190, 235, 1);
  static const Color darkGray = Color.fromRGBO(124, 124, 124, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}

class KMapColors {
  static const MaterialColor darkBlue = MaterialColor(
    0xFF004191,
    <int, Color>{
      50: Color.fromRGBO(230, 235, 246, 1),  // 90% white + 10% base
      100: Color.fromRGBO(204, 214, 237, 1),  // 80% white + 20% base
      200: Color.fromRGBO(179, 194, 228, 1),  // 70% white + 30% base
      300: Color.fromRGBO(153, 173, 218, 1),  // 60% white + 40% base
      400: Color.fromRGBO(128, 153, 209, 1),  // 50% white + 50% base
      500: Color.fromRGBO(102, 132, 200, 1),  // 40% white + 60% base
      600: Color.fromRGBO(77, 112, 191, 1),   // 30% white + 70% base
      700: Color.fromRGBO(51, 91, 182, 1),    // 20% white + 80% base
      800: Color.fromRGBO(26, 71, 173, 1),    // 10% white + 90% base
      900: Color.fromRGBO(0, 65, 145, 1),     // base color
    },
  );

  static const MaterialColor mediumBlue = MaterialColor(
    0xFF004187,
    <int, Color>{
      50: Color.fromRGBO(230, 235, 245, 1),
      100: Color.fromRGBO(204, 214, 235, 1),
      200: Color.fromRGBO(179, 194, 225, 1),
      300: Color.fromRGBO(153, 173, 215, 1),
      400: Color.fromRGBO(128, 153, 205, 1),
      500: Color.fromRGBO(102, 132, 195, 1),
      600: Color.fromRGBO(77, 112, 185, 1),
      700: Color.fromRGBO(51, 91, 175, 1),
      800: Color.fromRGBO(26, 71, 165, 1),
      900: Color.fromRGBO(0, 65, 135, 1),
    },
  );

  static const MaterialColor blue = MaterialColor(
    0xFF1487C8,
    <int, Color>{
      50: Color.fromRGBO(232, 244, 250, 1),
      100: Color.fromRGBO(209, 233, 245, 1),
      200: Color.fromRGBO(186, 222, 240, 1),
      300: Color.fromRGBO(162, 211, 235, 1),
      400: Color.fromRGBO(139, 200, 230, 1),
      500: Color.fromRGBO(116, 189, 225, 1),
      600: Color.fromRGBO(93, 178, 220, 1),
      700: Color.fromRGBO(69, 167, 215, 1),
      800: Color.fromRGBO(46, 156, 210, 1),
      900: Color.fromRGBO(20, 135, 200, 1),
    },
  );

  static const MaterialColor lightBlue = MaterialColor(
    0xFF5FBEEB,
    <int, Color>{
      50: Color.fromRGBO(239, 247, 253, 1),
      100: Color.fromRGBO(223, 239, 251, 1),
      200: Color.fromRGBO(207, 231, 249, 1),
      300: Color.fromRGBO(191, 223, 247, 1),
      400: Color.fromRGBO(175, 215, 245, 1),
      500: Color.fromRGBO(159, 207, 243, 1),
      600: Color.fromRGBO(143, 199, 241, 1),
      700: Color.fromRGBO(127, 191, 239, 1),
      800: Color.fromRGBO(111, 183, 237, 1),
      900: Color.fromRGBO(95, 190, 235, 1),
    },
  );

  static const MaterialColor darkGray = MaterialColor(
    0xFF7C7C7C,
    <int, Color>{
      50: Color.fromRGBO(241, 241, 241, 1),
      100: Color.fromRGBO(228, 228, 228, 1),
      200: Color.fromRGBO(215, 215, 215, 1),
      300: Color.fromRGBO(202, 202, 202, 1),
      400: Color.fromRGBO(189, 189, 189, 1),
      500: Color.fromRGBO(176, 176, 176, 1),
      600: Color.fromRGBO(163, 163, 163, 1),
      700: Color.fromRGBO(150, 150, 150, 1),
      800: Color.fromRGBO(137, 137, 137, 1),
      900: Color.fromRGBO(124, 124, 124, 1),
    },
  );

  static const MaterialColor white = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color.fromRGBO(255, 255, 255, 0.1),
      100: Color.fromRGBO(255, 255, 255, 0.2),
      200: Color.fromRGBO(255, 255, 255, 0.3),
      300: Color.fromRGBO(255, 255, 255, 0.4),
      400: Color.fromRGBO(255, 255, 255, 0.5),
      500: Color.fromRGBO(255, 255, 255, 0.6),
      600: Color.fromRGBO(255, 255, 255, 0.7),
      700: Color.fromRGBO(255, 255, 255, 0.8),
      800: Color.fromRGBO(255, 255, 255, 0.9),
      900: Color.fromRGBO(255, 255, 255, 1),
    },
  );
}