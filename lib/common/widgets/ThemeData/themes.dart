import 'package:flutter/material.dart';

// Định nghĩa màu sắc cho gradient background
const Color backgroundGradientStart = Color(0xFFFFF3E0);
const Color backgroundGradientcenter = Color(0xFFFFEE58);
const Color backgroundGradientEnd = Color(0xFFFFA726);

// Hàm để tạo gradient background
// CÁCH 1:
LinearGradient Themes() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundGradientStart,
      backgroundGradientcenter,
      backgroundGradientEnd,
    ],
  );
}


// CÁCH 2:
// LinearGradient Themes() {
//   return const LinearGradient(
//     colors: [
//       Color(0xFF87CEEB),
//     ],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//   );
// }