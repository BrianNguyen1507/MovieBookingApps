import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/models/order/Total.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/modules/timer/timer.dart';
import 'package:movie_booking_app/pages/order/components/orderWidget.dart';
import 'package:movie_booking_app/pages/order/components/voucherOrder.dart';
import 'package:movie_booking_app/pages/payments/payment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/food/getFoodById.dart';
import 'package:movie_booking_app/services/Users/movieDetail/movieDetailService.dart';
import 'package:movie_booking_app/services/Users/order/returnSeat/returnSeat.dart';

double newTotal = 0;
double discount = 0;
int voucherId = -1;

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
late Future<Food> foodData;
Preferences pref = Preferences();

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    widget.visible
        ? movieData = MovieDetailService.deatailMovieService(widget.movieId)
        : null;
    newTotal = widget.total.total;
    discount = widget.total.total - newTotal;
    super.initState();
  }

  @override
  void dispose() {
    Preferences().clearVoucher();
    TimerController.timerHoldSeatCancel();
    _handleAsyncDisposal();
    super.dispose();
  }

  void _handleAsyncDisposal() async {
    final latestSeats = await pref.getHoldSeats();

    if (widget.visible && latestSeats != null) {
      Set<String> prefSeats = ConverterUnit.convertStringToSet(latestSeats);
      dynamic scheduleId = await pref.getSchedule();
      print('seat was closed $prefSeats');
      await ReturnSeatService.returnSeat(scheduleId, prefSeats);

      await pref.clearHoldSeats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.containerColor),
        title: Text(
          AppLocalizations.of(context)!.order_inf,
          style: AppStyle.headline2,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        padding: const EdgeInsets.only(top: 10.0),
        decoration: const BoxDecoration(
            color: AppColors.commonLightColor,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(
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
                      //push den trang voucherOrder
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final responseTotal = await Navigator.push(
                                context,
                                ModalBottomSheetRoute(
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return VoucherOrder(
                                      total: widget.total.total,
                                    );
                                  },
                                ),
                              );
                              setState(() {
                                if (responseTotal != null) {
                                  newTotal = responseTotal['newTotal'];
                                  voucherId = responseTotal['voucherId'];
                                  discount = widget.total.total - newTotal;
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              width: AppSize.width(context),
                              decoration: const BoxDecoration(
                                color: AppColors.containerColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.string(
                                        svgVoucherCard,
                                        height: 35,
                                        width: 35,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .my_vouchers,
                                            style: AppStyle.bodyText1),
                                      ),
                                    ],
                                  ),
                                  Icon(AppIcon.arrowR),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildCustomerInfo(context),
                    ],
                  ),
                ),
              ),
            ),
            renderBooking(
              context,
              widget.total,
              widget.selectedSeat,
              widget.selectedFoods,
              widget.visible,
              widget.selectedTheater,
              widget.selectedDate,
              widget.selectedSchedule,
              widget.movieId,
            ),
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(AppLocalizations.of(context)!.movieDetail,
                    style: AppStyle.bodyText1),
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
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(
                            height: 90,
                            width: 60,
                            ConverterUnit.base64ToUnit8(getMovie.poster)),
                      ),
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
                          '${AppLocalizations.of(context)!.duration}: ${getMovie.duration.toString()} ${AppLocalizations.of(context)!.minutes}',
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
                          '${AppLocalizations.of(context)!.theater}: $selectedTheater',
                          style: AppStyle.smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: AppSize.width(context) * 0.6,
                          child: Text(
                            '${AppLocalizations.of(context)!.seats}: $selectedSeat',
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
        child: Text(
            '${AppLocalizations.of(context)!.fnd} (${selectedFoods.length})',
            style: AppStyle.bodyText1),
      ),
      SizedBox(
        height: selectedFoods.length * 90.0,
        child: ListView.builder(
          itemCount: selectedFoods.length,
          itemBuilder: (context, index) {
            final food = selectedFoods[index];
            return FutureBuilder<Food>(
              future: FindFoodService.getFoodById(food['id'].toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                } else {
                  final fdata = snapshot.data!;

                  return Card(
                    child: SizedBox(
                      height: 80,
                      child: ListTile(
                        leading: Image.memory(
                          height: 50,
                          width: 50,
                          ConverterUnit.base64ToUnit8(fdata.image),
                        ),
                        title: Text(
                          fdata.name,
                          style: AppStyle.detailText,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ConverterUnit.formatPrice(fdata.price)}₫',
                              style: AppStyle.smallText,
                            ),
                            Text(
                              'x${food['quantity']}',
                              style: AppStyle.smallText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
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
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(AppLocalizations.of(context)!.cus_inf,
            style: AppStyle.bodyText1),
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

Widget renderBooking(
  BuildContext context,
  GetTotal total,
  String seats,
  List<Map<String, dynamic>> foods,
  bool visible,
  String theater,
  String date,
  String time,
  int movieId,
) {
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
              Text(
                '${AppLocalizations.of(context)!.total}:',
                style: AppStyle.bodyText1,
              ),
              Row(
                children: [
                  Text(
                    '${ConverterUnit.formatPrice(newTotal)}₫',
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
                            child: buildBottomSheetOrder(context, total, seats,
                                foods, newTotal, discount, visible),
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    sumtotal: newTotal,
                    visible: visible,
                    foods: foods,
                    seats: seats,
                    theater: theater,
                    date: date,
                    time: time,
                    movieId: movieId,
                  ),
                )),
            child: Text(
              AppLocalizations.of(context)!.tieptuc,
              style: AppStyle.buttonNavigator,
            ),
          ),
        ),
      ],
    ),
  );
}
