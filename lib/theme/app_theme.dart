import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
        brightness: Brightness.light, // text gelap dengan background terang
        primary: Color(0xFFFFFFFF), // warna widget dasar
        onPrimary: Color(0xFF000000), // warna dari widget yang berada di atas widget dasar
        secondary: Color(0xFF000000), // warna dari widget aktivitas
        onSecondary: Color(0xFFFFFFFF), // warna dari widget yang ada di atas widget aktivitas
        error: Color(0xFFE30404), // warma wisget error
        onError: Color(0xFFFFFFFF), // warna dari widget yang ada di atas widget error
        surface: Color(0xFFFFFFFF), // warna dari widget permukaan widget tambahan
        onSurface: Color(0xFF000000) // warna dari widget yang ada di atas widget permukaan widget tambahan
    ),
    textTheme: TextTheme(
      // global
      // fontFamily: 'poppins',

      // text size
        displayLarge: TextStyle(
          fontSize: 20,
        ), // judul aplikasi di appbar
        displayMedium: TextStyle(
            fontSize: 18
        ), // deskripsi tambahan di appbar, judul fitur
        displaySmall: TextStyle(
            fontSize: 16
        ), // tab di appbar
        headlineLarge: TextStyle(
            fontSize: 16
        ), // judul list artikel,
        headlineMedium: TextStyle(
            fontSize: 14
        ), // deskripsi list artikel
        titleLarge: TextStyle(
            fontSize: 16
        ), // judul artikel
        titleMedium: TextStyle(
            fontSize: 14
        ), // deskripsi artikel
        bodyLarge: TextStyle(
            fontSize: 14
        ) // nama author,
      // bodyMedium: bodyMedium, // isi artikel
      // bodySmall: bodySmall, // tanggal posting artikel
      // labelLarge: labelLarge, // tombol aksi
      // labelMedium: labelMedium, // tombol aksi
      // labelSmall: labelSmall, // tombol aksi
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark, // text terang dengan background gelap
        primary: Color(0xFF000000), // warna widget dasar
        onPrimary: Color(0xFFFFFFFF), // warna dari widget yang berada di atas widget dasar
        secondary: Color(0xFFFFFFFF), // warna dari widget aktivitas
        onSecondary: Color(0xFF000000), // warna dari widget yang ada di atas widget aktivitas
        error: Color(0xFFCF6679), // warna widget error
        onError: Color(0xFF000000), // warna dari widget yang ada di atas widget error
        surface: Color(0xFF121212), // warna dari widget permukaan widget tambahan
        onSurface: Color(0xFFFFFFFF) // warna dari widget yang ada di atas widget permukaan widget tambahan
    ),
    textTheme: TextTheme(
      // global
      // fontFamily: 'poppins',

      // text size (sama seperti light theme)
        displayLarge: TextStyle(
          fontSize: 20,
        ), // judul aplikasi di appbar
        displayMedium: TextStyle(
            fontSize: 18
        ), // deskripsi tambahan di appbar, judul fitur
        displaySmall: TextStyle(
            fontSize: 16
        ), // tab di appbar
        headlineLarge: TextStyle(
            fontSize: 16
        ), // judul list artikel,
        headlineMedium: TextStyle(
            fontSize: 14
        ), // deskripsi list artikel
        titleLarge: TextStyle(
            fontSize: 16
        ), // judul artikel
        titleMedium: TextStyle(
            fontSize: 14
        ), // deskripsi artikel
        bodyLarge: TextStyle(
            fontSize: 14
        ) // nama author,
    ),
  );
}
