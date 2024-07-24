import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/services/Users/ratingFeedback/ratingFeedbackService.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

int rating = 0;

class RatingFeedbackPage extends StatefulWidget {
  const RatingFeedbackPage({super.key, required this.order});

  final OrderResponse order;

  @override
  State<StatefulWidget> createState() {
    return RatingFeedbackState();
  }
}

class RatingFeedbackState extends State<RatingFeedbackPage> {
  TextEditingController commentCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What do you think about the movie?',
              style: AppStyle.headline1,
            ),
            const RatingWidget(),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: commentCtl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comment',
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                dynamic result =
                    await RatingFeedbackService.createRatingFeedback(
                  rating,
                  commentCtl.text,
                  widget.order.id.toInt(),
                  context,
                );

                if (result == '1000') {
                  Navigator.pop(context,result);
                } else {
                  ValidInput().showAlertCustom(
                    context,
                    result,
                    '',
                    true,
                    () {},
                  );
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: AppFontSize.medium,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingWidget extends StatefulWidget {
  const RatingWidget({super.key});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  Widget _buildStar(int index) {
    if (index < rating) {
      return const Icon(Icons.star, color: AppColors.startRating, size: 40);
    } else {
      return const Icon(Icons.star_border,
          color: AppColors.commonColor, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  rating = index + 1;
                });
              },
              child: _buildStar(index),
            );
          }),
        ),
        Text(RatingContent.contentRating(context, rating),
            style: AppStyle.graySmallText),
      ],
    );
  }
}
