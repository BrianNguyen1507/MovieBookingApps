import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';

import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/models/order/Total.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/order/components/orderWidget.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
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
        backgroundColor: AppColors.backgroundColor.withOpacity(0.05),
        iconTheme: const IconThemeData(color: AppColors.backgroundColor),
        title: const Text(
          'Order Information',
          style: AppStyle.headline1,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.commonLightColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration:
                    const BoxDecoration(color: AppColors.commonLightColor),
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
                    buildVoucherInfo(context),
                    buildCustomerInfo(context),
                  ],
                ),
              ),
            ),
          ),
          renderBooking(
              context, widget.total, widget.selectedSeat, widget.selectedFoods),
        ],
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
                        SizedBox(
                          width: AppSize.width(context) * 0.6,
                          child: Text(
                            'Seats: $selectedSeat',
                            style: AppStyle.smallText,
                          ),
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
        height: selectedFoods.length * 80,
        child: ListView.builder(
          itemCount: selectedFoods.length,
          itemBuilder: (context, index) {
            final food = selectedFoods[index];
            return Card(
              child: SizedBox(
                height: 70,
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

Widget buildCustomerInfo(BuildContext context) {
  Preferences pref = Preferences();
  Future<String?> getMail = pref.getEmail();
  Future<String?> getName = pref.getUserName();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text('Customer Infomation', style: AppStyle.bodyText1),
      ),
      Container(
        padding: const EdgeInsets.all(10.0),
        width: AppSize.width(context),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: AppColors.containerColor,
        ),
        child: FutureBuilder(
          future: Future.wait([getMail, getName]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: loadingContent);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              String? mail = snapshot.data![0];
              String? name = snapshot.data![1];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mail!,
                    style: AppStyle.titleOrder,
                  ),
                  Text(
                    name!,
                    style: AppStyle.graySmallText,
                  ),
                ],
              );
            }
          },
        ),
      ),
    ],
  );
}

Widget buildVoucherInfo(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: AppSize.width(context),
                    child: const Text('123'));
              });
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          width: AppSize.width(context),
          decoration: const BoxDecoration(
            color: AppColors.containerColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.string(
                    svgVoucher,
                    height: 35,
                    width: 35,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text('My voucher wallet', style: AppStyle.bodyText1),
                  ),
                ],
              ),
              Icon(AppIcon.arrowR),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget renderBooking(BuildContext context, GetTotal total, String seats,
    List<Map<String, dynamic>> foods) {
  return Container(
    decoration: const BoxDecoration(
      color: AppColors.containerColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
    ),
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    width: double.infinity,
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL:',
                style: AppStyle.bodyText1,
              ),
              Row(
                children: [
                  Text(
                    '${ConverterUnit.formatPrice(total.total)}₫',
                    style: AppStyle.bodyText1,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: AppColors.containerColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            height: AppSize.height(context),
                            width: AppSize.width(context),
                            child: buildBottomSheetOrder(total, seats, foods),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor.withOpacity(0.12),
                          shape: BoxShape.circle),
                      child: Icon(
                        AppIcon.questionMark,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: AppSize.width(context),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () async {},
            child: const Text(
              'CONTINUE',
              style: AppStyle.buttonNavigator,
            ),
          ),
        ),
      ],
    ),
  );
}
