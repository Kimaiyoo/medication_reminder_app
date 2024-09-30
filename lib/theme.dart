import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 11, 212, 202),
    onSecondary: Colors.white,
    error: Color.fromARGB(255, 236, 38, 38),
    onError: Colors.white,
    surface: Color.fromARGB(255, 248, 245, 245),
    onSurface: Color.fromARGB(255, 22, 22, 22));

const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 11, 212, 202),
    onSecondary: Colors.white,
    error: Color.fromARGB(255, 236, 38, 38),
    onError: Colors.white,
    surface: Color.fromARGB(255, 248, 245, 245),
    onSurface: Color.fromARGB(255, 22, 22, 22));

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // Use the color scheme for primary color
      backgroundColor: lightColorScheme.primary,
      // Foreground color for text and icons
      foregroundColor: Colors.white,
      // Elevation for the button to give shadow effect
      elevation: 5.0,
      // Padding inside the button
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      // Rounded corners for the button
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16), // Adjust corner radius as needed
      ),
    ),
  ),
  // Optional: Customize other button themes (TextButton, OutlinedButton) if needed
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightColorScheme.primary, // Text color for TextButton
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor:
          lightColorScheme.primary, // Text color for OutlinedButton
      side: BorderSide(color: lightColorScheme.primary), // Border color
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  // Customize other theme elements like AppBar, FloatingActionButton, etc.
  appBarTheme: AppBarTheme(
    color: lightColorScheme.primaryContainer, // Background color for AppBar
    foregroundColor:
        lightColorScheme.onPrimaryContainer, // Text color for AppBar
    elevation: 0, // AppBar shadow
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // Use the color scheme for primary color
      backgroundColor: lightColorScheme.primary,
      // Foreground color for text and icons
      foregroundColor: Colors.white,
      // Elevation for the button to give shadow effect
      elevation: 5.0,
      // Padding inside the button
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      // Rounded corners for the button
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16), // Adjust corner radius as needed
      ),
    ),
  ),
  // Optional: Customize other button themes (TextButton, OutlinedButton) if needed
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightColorScheme.primary, // Text color for TextButton
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor:
          lightColorScheme.primary, // Text color for OutlinedButton
      side: BorderSide(color: lightColorScheme.primary), // Border color
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  // Customize other theme elements like AppBar, FloatingActionButton, etc.
  appBarTheme: AppBarTheme(
    color: lightColorScheme.primaryContainer, // Background color for AppBar
    foregroundColor:
        lightColorScheme.onPrimaryContainer, // Text color for AppBar
    elevation: 0, // AppBar shadow
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
);
