import 'package:flutter/foundation.dart';

class RatingFeedback{
  BigInt id;
  int rating;
  String comment;

  RatingFeedback({required this.id,required this.rating,required this.comment});

  factory RatingFeedback.fromJson(Map<String,dynamic> json){
    return RatingFeedback(
        id: BigInt.from(json['id']),
        rating: (json['rating']as num).toInt(),
        comment: json['comment']
    );
  }
}