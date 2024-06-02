import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/provider/provider.dart';

import 'package:movie_booking_app/constant/appdata.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance.addPostFrameCallback((_) => initSignIn(context));
  }

  Future<void> initSignIn(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.trySignIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Center(
          child: Container(
            width: AppSize.width(context),
            height: AppSize.height(context),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue,
                ],
              ),
            ),
            child: const Text(
              'SPLASH SCREEN',
              style: TextStyle(fontSize: 100),
            ),
          ),
        ),
      ),
    );
  }
}
