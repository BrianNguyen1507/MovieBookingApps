import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/services/Users/ratingFeedback/ratingFeedbackService.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Order"),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: AppFontSize.medium,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: AppSize.width(context),
          height: AppSize.height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSize.width(context),
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                            ConverterUnit.base64ToUnit8(widget.order.poster)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              " ${widget.order.title}",
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              " Duration: ${widget.order.duration} minute",
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              " Release Date: ${ConverterUnit.formatToDmY(widget.order.releaseDate)}",
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: ClassifyClass.toFlutterColor(
                                ClassifyClass.classifyType(
                                    widget.order.classify),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(3.0),
                              ),
                            ),
                            child: Text(
                              widget.order.classify,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.containerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Text"),
                      RatingWidget(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: AppSize.width(context) - 100,
                        height: 300,
                        child: TextField(
                          controller: commentCtl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Comment',
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    await RatingFeedbackService.createRatingFeedback(rating,
                        commentCtl.text, widget.order.id.toInt(), context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appbarColor,
                  ),
                  child: const SizedBox(
                    width: 300,
                    child: Padding(
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
                  ))
            ],
          ),
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
      return const Icon(Icons.star, color: Colors.yellow, size: 40);
    } else {
      return const Icon(Icons.star_border, color: Colors.grey, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
    );
  }
}
