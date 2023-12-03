import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_bloc.dart';
import 'package:jobhunt_mobile/blocs/darkTheme/dark_theme_bloc.dart';

import 'package:jobhunt_mobile/firebase_options.dart';

import 'package:jobhunt_mobile/views/Auth/authFlow.dart';

import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<DarkThemeBloc>(
          // Add BlocProvider for DarkThemeBloc
          create: (context) => DarkThemeBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

init() async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return BlocBuilder<DarkThemeBloc, ThemeState>(
        builder: (context, state) {
          // Check the state to determine the current theme
          bool isDarkMode = state is SetDarkThemeState;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: FlexThemeData.light(
              scheme: FlexScheme.blue,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 7,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                alignedDropdown: true,
                useInputDecoratorThemeInDialogs: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.blue,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 13,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                alignedDropdown: true,
                useInputDecoratorThemeInDialogs: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            home: AuthenticationFlowScreen(),
          );
        },
      );
    });
  }
}
