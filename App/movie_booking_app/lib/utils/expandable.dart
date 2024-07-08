import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
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
              ? Text(isExpanded ? 'Show less' : 'Show more',
                  style: AppStyle.buttonText)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
