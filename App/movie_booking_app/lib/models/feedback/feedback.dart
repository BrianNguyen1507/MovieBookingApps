class RatingFeedback {
  final String comment;
  final int rating;
  final String datetime;
  final String fullName;
  final String avatar;

  RatingFeedback({
    required this.comment,
    required this.rating,
    required this.datetime,
    required this.fullName,
    required this.avatar,
  });

  factory RatingFeedback.fromjson(Map<String, dynamic> json) {
    return RatingFeedback(
      comment: json['comment'],
      rating: json['rating'],
      datetime: json['datetime'],
      fullName: json['fullName'],
      avatar: json['avatar'],
    );
  }
}
