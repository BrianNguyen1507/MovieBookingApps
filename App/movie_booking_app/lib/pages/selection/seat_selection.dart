import 'dart:async';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/constant/svg_string.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie_detail.dart';
import 'package:movie_booking_app/models/order/get_total.dart';
import 'package:movie_booking_app/models/seat/seat.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/selection/components/seat-widget/seat_widgets.dart';
import 'package:movie_booking_app/pages/store/store.dart';
import 'package:movie_booking_app/services/Users/movie-detail/movie_detail_service.dart';
import 'package:movie_booking_app/services/Users/order/get-total/get_total_service.dart';
import 'package:movie_booking_app/services/Users/seat/seat_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';

class SeatSelection extends StatefulWidget {
  final int scheduleId;
  final String theaterName;
  final int roomNumber;
  final int movieId;
  final String date;
  final String time;
  const SeatSelection({
    super.key,
    required this.time,
    required this.scheduleId,
    required this.theaterName,
    required this.movieId,
    required this.roomNumber,
    required this.date,
  });

  @override
  State<SeatSelection> createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  late Future<Seat?> seats;
  late Future<MovieDetail?> getMovie;
  late Future<GetTotal?> getTotal;
  Set<String> selectedSeats = {};

  @override
  void initState() {
    super.initState();
    seats = Seatservice.getMovieScheduleById(context, widget.scheduleId);
    getMovie = MovieDetailService.deatailMovieService(context, widget.movieId);
    getTotal = _fetchTotal();
  }

  Future<GetTotal?> _fetchTotal() {
    return GetTotalService.sumTotalOrder(
      widget.movieId,
      selectedSeats.length,
      [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Common.leadingArrowPop(context, AppColors.iconThemeColor),
          backgroundColor: AppColors.opacityBlackColor,
          centerTitle: true,
          title: seatStateList(context),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<Seat?>(
                          future: seats,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return loadingData(context);
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              final seatData = snapshot.data!;
                              return buildSeatMap(seatData);
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: renderBooking(
                      context,
                      widget.date,
                      widget.time,
                      widget.theaterName,
                      widget.roomNumber,
                      widget.scheduleId,
                      widget.movieId,
                      getMovie,
                      getTotal,
                      selectedSeats,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSeatMap(Seat seatData) {
    List<String> rowLabels = List.generate(seatData.seats.length, (index) {
      return String.fromCharCode(index + 65);
    });
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: InteractiveViewer(
          constrained: true,
          minScale: 0.1,
          maxScale: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Exit',
                        style: AppStyle.smallText,
                      ),
                      SvgPicture.asset(
                        'assets/svg/logout.svg',
                        height: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.screen,
                        style: AppStyle.screenText,
                      ),
                      SvgPicture.string(
                        svgScreen,
                        height: 50.0,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'Exit',
                        style: AppStyle.smallText,
                      ),
                      SvgPicture.asset(
                        'assets/svg/logout-revert.svg',
                        height: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 30.0),
                height: AppSize.height(context) / 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Column(
                        children: List.generate(
                          seatData.seats.length,
                          (index) {
                            return buildSeatRow(
                                seatData.seats[index], index + 1, rowLabels);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSeatRow(
      List<dynamic> seatRow, int rowIndex, List<String> rowLabels) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: Text(
                rowLabels[rowIndex - 1],
                style: AppStyle.smallText,
              ),
            ),
            ...seatRow.asMap().entries.map((entry) {
              int seatIndex = entry.key;
              int seatStatus = entry.value;
              String seatIdentifier =
                  '${rowLabels[rowIndex - 1]}${seatIndex + 1}';
              bool isSelectable =
                  seatStatus != 1 && seatStatus != 2 && seatStatus != 3;
              bool isSelected = selectedSeats.contains(seatIdentifier);
              Color seatColor = SeatClass.getSeatColor(seatStatus);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelectable) {
                      if (isSelected) {
                        selectedSeats.remove(seatIdentifier);
                      } else {
                        selectedSeats.add(seatIdentifier);
                      }
                    }
                    getTotal = _fetchTotal();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor.withOpacity(0.76)
                        : seatColor,
                    borderRadius: ContainerRadius.radius2,
                  ),
                  child: Center(
                    child: Text(
                      seatIdentifier,
                      style: AppStyle.seatText,
                    ),
                  ),
                ),
              );
            }),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: Text(
                rowLabels[rowIndex - 1],
                style: AppStyle.smallText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget renderBooking(
    BuildContext context,
    String date,
    String times,
    String theaterName,
    int roomNumber,
    int scheduleId,
    int movieId,
    Future<MovieDetail?> movieInfo,
    Future<GetTotal?> totalInfo,
    Set<String> selectedSeats) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<MovieDetail?>(
          future: movieInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final movieData = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: ContainerRadius.radius5,
                              child: FutureBuilder<Uint8List>(
                                future: ConverterUnit.bytesToImage(
                                    movieData.poster),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Uint8List> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox();
                                  } else if (snapshot.hasError) {
                                    return const SizedBox();
                                  } else {
                                    return Image.memory(
                                      cacheHeight: 70,
                                      cacheWidth: 50,
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(2.0),
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                        color: ClassifyClass.toFlutterColor(
                                          ClassifyClass.classifyType(
                                              movieData.classify),
                                        ),
                                        borderRadius: ContainerRadius.radius2,
                                      ),
                                      child: Text(
                                        ClassifyClass.convertNamed(
                                            movieData.classify),
                                        style: AppStyle.classifyText,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        ' ${movieData.title}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyle.smallText,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                    '${movieData.duration} ${AppLocalizations.of(context)!.minutes}',
                                    maxLines: 1,
                                    style: AppStyle.smallText),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(theaterName, style: AppStyle.smallText),
                            Text(
                                '${AppLocalizations.of(context)!.room}: $roomNumber',
                                style: AppStyle.smallText),
                            Text(
                                '${AppLocalizations.of(context)!.show_time}: $times',
                                style: AppStyle.smallText),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        FutureBuilder<GetTotal?>(
          future: totalInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError) {
              return const SizedBox.shrink();
            } else if (snapshot.hasData) {
              final data = snapshot.data!;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.seats}: ',
                      style: AppStyle.bodyText1,
                      children: <TextSpan>[
                        TextSpan(
                          text: '${selectedSeats.length}',
                          style: AppStyle.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.total}: ',
                      style: AppStyle.bodyText1,
                      children: <TextSpan>[
                        TextSpan(
                          text: ConverterUnit.formatPrice(data.priceMovie),
                          style: AppStyle.bodyText1,
                        ),
                        TextSpan(
                          text: '₫',
                          style: AppStyle.bodyText1,
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: ContainerRadius.radius10),
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () async {
              if (selectedSeats.isEmpty) {
                ShowDialog.showAlertCustom(
                    context,
                    AppLocalizations.of(context)!.seat_noti,
                    '',
                    true,
                    null,
                    DialogType.info);
                return;
              }

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return StorePage(
                    date: date,
                    theater: theaterName,
                    room: roomNumber,
                    schedule: times,
                    scheduleId: scheduleId,
                    selection: true,
                    movieId: movieId,
                    seats: selectedSeats,
                  );
                },
              );
            },
            child: Text(
              AppLocalizations.of(context)!.booking,
              style: AppStyle.buttonNavigator,
            ),
          ),
        ),
      ],
    ),
  );
}
