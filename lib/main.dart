import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_bloc.dart';

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
      ],
      child: MyApp(),
    ),
  );
}

init() async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        title: 'Flutter Demo',
        // Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xff004881),
            primaryContainer: Color(0xffd0e4ff),
            secondary: Color(0xffac3306),
            secondaryContainer: Color(0xffffdbcf),
            tertiary: Color(0xff006875),
            tertiaryContainer: Color(0xff95f0ff),
            appBarColor: Color(0xffffdbcf),
            error: Color(0xffb00020),
          ),
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
          fontFamily: GoogleFonts.chivo().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          colors: const FlexSchemeColor(
            primary: Color(0xff9fc9ff),
            primaryContainer: Color(0xff00325b),
            secondary: Color(0xffffb59d),
            secondaryContainer: Color(0xff872100),
            tertiary: Color(0xff86d2e1),
            tertiaryContainer: Color(0xff004e59),
            appBarColor: Color(0xff872100),
            error: Color(0xffcf6679),
          ),
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
          fontFamily: GoogleFonts.chivo().fontFamily,
        ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

        home: AuthenticationFlowScreen(),
      );
    }));
  }
}
