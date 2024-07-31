import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/movie/movie_detail.dart';
import 'package:movie_booking_app/models/order/get_total.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/modules/timer/timer.dart';
import 'package:movie_booking_app/pages/order/components/movie_card.dart';
import 'package:movie_booking_app/pages/order/components/order_widgets.dart';
import 'package:movie_booking_app/pages/order/components/voucher_tab.dart';
import 'package:movie_booking_app/pages/payments/payment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/services/Users/food/get_food_id.dart';
import 'package:movie_booking_app/services/Users/movie-detail/movie_detail_service.dart';
import 'package:movie_booking_app/services/Users/order/return-seat/return_seat_service.dart';

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
  final GetTotal? total;
  final int movieId;
  final String selectedDate;
  final String selectedTheater;
  final String selectedSchedule;
  final String selectedSeat;

  final List<Map<String, dynamic>> selectedFoods;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

late Future<MovieDetail?> movieData;
late Future<Food> foodData;
Preferences pref = Preferences();

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    widget.visible
        ? movieData =
            MovieDetailService.deatailMovieService(context, widget.movieId)
        : null;
    newTotal = widget.total!.total;
    discount = widget.total!.total - newTotal;
    super.initState();
  }

  @override
  void dispose() {
    Preferences().clearVoucher();
    TimerController.timerHoldSeatCancel();
    _handleAsyncDisposal(context);
    super.dispose();
  }

  void _handleAsyncDisposal(context) async {
    final latestSeats = await pref.getHoldSeats();

    if (widget.visible && latestSeats != null) {
      Set<String> prefSeats = ConverterUnit.convertStringToSet(latestSeats);
      dynamic scheduleId = await pref.getSchedule();
      debugPrint('seat was closed $prefSeats');
      await ReturnSeatService.returnSeat(context, scheduleId, prefSeats);

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
        padding: const EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
            color: AppColors.commonLightColor,
            borderRadius: ContainerRadius.radius20),
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
                          ? Column(
                              children: [
                                buildMovieInfo(
                                  movieData,
                                ),
                                buildSelectionInfo(
                                    context,
                                    widget.selectedDate,
                                    widget.selectedTheater,
                                    widget.selectedSchedule,
                                    widget.selectedSeat)
                              ],
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
                                      total: widget.total!.total,
                                    );
                                  },
                                ),
                              );
                              setState(() {
                                if (responseTotal != null) {
                                  newTotal = responseTotal['newTotal'];
                                  voucherId = responseTotal['voucherId'];
                                  discount = widget.total!.total - newTotal;
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
                                      SvgPicture.asset(
                                        'assets/svg/discount-voucher.svg',
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
              widget.total!,
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

Widget buildSelectionInfo(
  BuildContext context,
  String selectedDate,
  String selectedTheater,
  String selectedSchedule,
  String selectedSeat,
) {
  final numberSeats = ConverterUnit.convertStringToSet(selectedSeat).length;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
            '${AppLocalizations.of(context)!.selectionDetail} ($numberSeats)',
            style: AppStyle.bodyText1),
      ),
      Container(
        padding: const EdgeInsets.all(10.0),
        width: AppSize.width(context),
        decoration: BoxDecoration(
          borderRadius: ContainerRadius.radius12,
          color: AppColors.containerColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppLocalizations.of(context)!.theater}:',
                    style: AppStyle.bodyText1),
                Text(selectedTheater, style: AppStyle.paymentInfoText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppLocalizations.of(context)!.show_time}:',
                    style: AppStyle.bodyText1),
                Text(
                    '${ConverterUnit.formatToDmY(selectedDate)} | $selectedSchedule',
                    style: AppStyle.paymentInfoText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppLocalizations.of(context)!.seats}:',
                    style: AppStyle.bodyText1),
                SizedBox(
                  width: numberSeats > 10 ? AppSize.width(context) * 0.6 : null,
                  child: Text(
                    selectedSeat,
                    style: AppStyle.paymentInfoText,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildMovieInfo(
  Future<MovieDetail?> fetchMovieData,
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
        return movieCard(context, getMovie);
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
            return FutureBuilder<Food?>(
              future:
                  FindFoodService.getFoodById(food['id'].toString(), context),
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
                    color: AppColors.containerColor,
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
        decoration: BoxDecoration(
          borderRadius: ContainerRadius.radius12,
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
                borderRadius: ContainerRadius.radius10,
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
