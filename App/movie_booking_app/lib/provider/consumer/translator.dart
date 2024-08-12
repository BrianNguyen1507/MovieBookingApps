import 'package:flutter/material.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';

class TranslateConsumer {
  Consumer<ThemeProvider> translateProvider(
      String content, int? maxLine, TextStyle textStyle) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<String>(
          future: provider.translateText(content),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? content,
              maxLines: maxLine,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            );
          },
        );
      },
    );
  }
}
