import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ratingfeedback/RatingFeedback.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingFeedbackWidget extends StatefulWidget {
  final Future<List<RatingFeedback>> listFeedback;

  RatingFeedbackWidget({required this.listFeedback});

  @override
  _RatingFeedbackWidgetState createState() => _RatingFeedbackWidgetState();
}

class _RatingFeedbackWidgetState extends State<RatingFeedbackWidget> {
  int countFeedback = 0;
  double averageRating = 0.0;
  bool showAllFeedback = false;
  @override
  void initState() {
    super.initState();
    widget.listFeedback.then((feedback) {
      setState(() {
        countFeedback = feedback.length;
        averageRating = ConverterUnit.calculateAverageRating(feedback);
      });
    }).catchError((error) {
      print('Error fetching feedback: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.rating_feedback,
                  style: AppStyle.bodyText1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        AppIcon.star,
                        color: AppColors.startRating,
                      ),
                      Text(
                        '$averageRating/5',
                        style: AppStyle.headline1,
                      ),
                    ],
                  ),
                  Text(
                      '($countFeedback ${AppLocalizations.of(context)!.feedback})',
                      style: AppStyle.smallText),
                ],
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.35,
          ),
          FutureBuilder<List<RatingFeedback>>(
            future: widget.listFeedback,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: loadingContent);
              } else if (snapshot.hasError) {
                return const SizedBox.shrink();
              } else if (snapshot.hasData) {
                final feedback = snapshot.data!;
                final limitedFeedback = showAllFeedback
                    ? feedback
                    : (feedback.length > 4 ? feedback.sublist(0, 4) : feedback);
                return Column(
                  children: [
                    SizedBox(
                      height: limitedFeedback.length * 130.0,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: limitedFeedback.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6.0,
                                  color: AppColors.shadowColor,
                                  offset: Offset(2, 1),
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                              color: AppColors.containerColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ClipOval(
                                        child: Image.memory(
                                          ConverterUnit.base64ToUnit8(
                                              feedback[index].avatar),
                                          fit: BoxFit.cover,
                                          width: 30.0,
                                          height: 30.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          feedback[index].fullName,
                                          style: AppStyle.priceText,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.commented} ${feedback[index].datetime}',
                                          style: AppStyle.smallText,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      AppIcon.star,
                                      color: AppColors.startRating,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${feedback[index].rating}/5',
                                          style: AppStyle.priceText,
                                        ),
                                        Text(
                                          ' ${RatingContent.contentRating(context, feedback[index].rating)}',
                                          style: AppStyle.smallText,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  ' ${feedback[index].comment}',
                                  style: AppStyle.smallText,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (feedback.length > 4)
                      SizedBox(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              AppColors.backgroundColor.withOpacity(0.5),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showAllFeedback = !showAllFeedback;
                            });
                          },
                          label: Text(
                            showAllFeedback
                                ? AppLocalizations.of(context)!.showless
                                : '${AppLocalizations.of(context)!.showmore} (${feedback.length - 4})',
                            style: AppStyle.buttonText2,
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
