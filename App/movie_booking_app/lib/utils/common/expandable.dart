import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
  });

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return FutureBuilder(
              future: provider.translateText(widget.text),
              builder: (context, snapshot) {
                final textTrans = snapshot.data ?? widget.text;
                return Text(
                  textTrans,
                  maxLines: isExpanded ? null : widget.maxLines,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: AppStyle.detailTitle,
                );
              },
            );
          },
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: widget.text.length > 50
              ? Text(
                  isExpanded
                      ? AppLocalizations.of(context)!.showless
                      : AppLocalizations.of(context)!.showmore,
                  style: AppStyle.buttonText)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
