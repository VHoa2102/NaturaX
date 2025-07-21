import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:springr/utils/constants.dart';
import 'package:springr/utils/pallete.dart';
import 'package:springr/utils/routes.dart';
import 'package:provider/provider.dart';

import 'package:springr/providers/password_provider.dart';
import 'package:springr/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PasswordProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: MaterialApp(
          title: 'SpringR',
          theme: ThemeData(
            primarySwatch: Palette.primaryPaletteColor,
            scaffoldBackgroundColor: scaffoldColor,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: primaryColor,
              selectionHandleColor: primaryColor,
            ),
          ),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: RouteGenerator.splashPage,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
