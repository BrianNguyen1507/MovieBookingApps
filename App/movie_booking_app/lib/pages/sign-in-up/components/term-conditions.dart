import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

void showTermsAndConditionsBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.termhead,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.line1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.line2,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line3,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.line4,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.line5,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line6,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line7,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line8,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.line9,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.line10,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line11,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line12,
                          ),
                          Text(
                            AppLocalizations.of(context)!.line13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(AppIcon.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
