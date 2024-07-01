import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';

import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/models/order/Total.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/services/Users/movieDetail/movieDetailService.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
    required this.visible,
    required this.total,
    required this.movieId,
    required this.selectedDate,
    required this.selectedTheater,
    required this.selectedSchedule,
    required this.selectedSeat,
    required this.selectedFoods,
  });
  final bool visible;
  final GetTotal total;
  final int movieId;
  final String selectedDate;
  final String selectedTheater;
  final String selectedSchedule;
  final String selectedSeat;

  final List<Map<String, dynamic>> selectedFoods;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

late Future<MovieDetail> movieData;

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    widget.visible
        ? movieData = MovieDetailService.deatailMovieService(widget.movieId)
        : null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.containerColor),
        title: const Text(
          'Order Infomation',
          style: AppStyle.bodyText1,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(color: AppColors.commonLightColor),
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.visible
                ? buildMovieInfo(
                    movieData,
                    widget.selectedDate,
                    widget.selectedTheater,
                    widget.selectedSchedule,
                    widget.selectedSeat,
                  )
                : const SizedBox.shrink(),
            buildFoodInfo(context, widget.selectedFoods),
            const Text('Voucher wallet', style: AppStyle.bodyText1),
            const Text('Payment Method', style: AppStyle.bodyText1),
            const Text('Customer information', style: AppStyle.bodyText1),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget buildMovieInfo(
  Future<MovieDetail> fetchMovieData,
  String selectedDate,
  String selectedTheater,
  String selectedSchedule,
  String selectedSeat,
) {
  return FutureBuilder(
    future: movieData,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loadingData(context);
      } else if (snapshot.hasError) {
        return loadingContent;
      } else {
        final getMovie = snapshot.data as MovieDetail;
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text('Movie Infomation', style: AppStyle.bodyText1),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: AppSize.width(context),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: .0,
                      color: AppColors.shadowColor,
                      offset: Offset(1, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.containerColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.memory(
                          height: 100,
                          width: 80,
                          ConverterUnit.base64ToUnit8(getMovie.poster)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 2.0),
                              decoration: BoxDecoration(
                                color: ClassifyClass.toFlutterColor(
                                  ClassifyClass.classifyType(getMovie.classify),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2),
                                ),
                              ),
                              padding: const EdgeInsets.all(1.5),
                              child: Text(
                                getMovie.classify,
                                style: AppStyle.classifyText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              getMovie.title,
                              style: AppStyle.titleOrder,
                            ),
                          ],
                        ),
                        Text(
                          'Duration: ${getMovie.duration.toString()} minutes',
                          style: AppStyle.smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${ConverterUnit.formatToDmY(selectedDate)} | $selectedSchedule',
                          style: AppStyle.smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Theater: $selectedTheater',
                          style: AppStyle.smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Seats: $selectedSeat',
                          style: AppStyle.smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

Widget buildFoodInfo(
  BuildContext context,
  List<Map<String, dynamic>> selectedFoods,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text('Food and drinks (${selectedFoods.length})',
            style: AppStyle.bodyText1),
      ),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedFoods.length,
          itemBuilder: (context, index) {
            final food = selectedFoods[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: Text(food['id'].toString()),
                  subtitle: const Text('123'),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
