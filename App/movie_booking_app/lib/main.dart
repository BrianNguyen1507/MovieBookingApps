import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/l10n/l10n.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:flutter_localizations/flutter_localizations.dart' as AL;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SafeArea(
          child: MaterialApp(
            title: 'Movie Booking Tickets',
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splashScreen,
            routes: AppRoutes.routes,
            supportedLocales: L10n.language,
            locale: themeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              AL.GlobalMaterialLocalizations.delegate,
              AL.GlobalWidgetsLocalizations.delegate,
              AL.GlobalCupertinoLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }
}
