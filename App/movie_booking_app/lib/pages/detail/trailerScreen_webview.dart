import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

import 'package:webview_flutter/webview_flutter.dart';

class TrailerScreen extends StatefulWidget {
  const TrailerScreen({super.key, required this.urlResponse});
  final String urlResponse;

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

late WebViewController controller;

class _TrailerScreenState extends State<TrailerScreen> {
  bool isVideoLoaded = false;
  bool isFullscreen = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_getYouTubeEmbedUrl(widget.urlResponse)))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              isVideoLoaded = true;
            });
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.iconThemeColor),
      ),
      body: Center(
        child: !isVideoLoaded
            ? const CircularProgressIndicator(
                color: AppColors.iconThemeColor,
              )
            : GestureDetector(
                onTap: _toggleFullscreen,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: WebViewWidget(controller: controller),
                ),
              ),
      ),
    );
  }

  void _toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
      if (isFullscreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _getYouTubeEmbedUrl(String url) {
    final videoId = _extractYouTubeId(url);
    String embed =
        'https://www.youtube.com/embed/$videoId?autoplay=1&modestbranding=1';
    return embed;
  }

  String _extractYouTubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }
}
