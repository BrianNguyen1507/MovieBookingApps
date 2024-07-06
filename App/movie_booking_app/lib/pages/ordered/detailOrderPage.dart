import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/models/ordered/DetailOrder.dart';
import 'package:movie_booking_app/models/ratingfeedback/RatingFeedback.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/ordered/components/detailWidget.dart';
import 'package:movie_booking_app/services/Users/ordered/detailOrderService.dart';
import 'package:movie_booking_app/services/Users/ratingFeedback/ratingFeedbackService.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({super.key, required this.id});
  final int id;
  @override
  State<StatefulWidget> createState() {
    return DetailOrderPageState();
  }
}

class DetailOrderPageState extends State<DetailOrderPage> {
  late Future<DetailOrder> orderFuture;
  late RatingFeedback ratingFeedback;
  @override
  void initState() {
    super.initState();
    orderFuture = DetailOrderService.detailOrder(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Detail Order"),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: AppStyle.bannerText,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.iconThemeColor,
        ),
      ),
      body: FutureBuilder<DetailOrder>(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingData(context);
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          } else {
            DetailOrder order = snapshot.data!;
            return SingleChildScrollView(
                child: order.seat.isNotEmpty
                    ? detailOrderFilm(context, order)
                    : detailOrderFood(context, order));
          }
        },
      ),
    );
  }
}
