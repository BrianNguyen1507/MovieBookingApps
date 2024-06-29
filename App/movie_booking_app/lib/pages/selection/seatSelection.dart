import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/models/seat/seat.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/services/Users/movieDetail/movieDetailService.dart';
import 'package:movie_booking_app/services/Users/seat/seatService.dart';

class SeatSelection extends StatefulWidget {
  final int scheduleId;
  final String theaterName;
  final int roomNumber;
  final int movieId;
  const SeatSelection(
      {super.key,
      required this.scheduleId,
      required this.theaterName,
      required this.movieId,
      required this.roomNumber});

  @override
  State<SeatSelection> createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  late Future<Seat> seats;
  late Future<MovieDetail> getMovie;

  Set<String> selectedSeats = {};

  @override
  void initState() {
    super.initState();
    seats = Seatservice.getMovieScheduleById(widget.scheduleId);
    getMovie = MovieDetailService.deatailMovieService(widget.movieId);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.opacityBlackColor,
          iconTheme: const IconThemeData(color: AppColors.containerColor),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: FutureBuilder<Seat>(
                    future: seats,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                widget.theaterName,
                widget.roomNumber,
                getMovie,
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
    return InteractiveViewer(
      constrained: true,
      minScale: 0.5,
      maxScale: 20.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'S C R E E N',
                  style: AppStyle.screenText,
                ),
                SvgPicture.string(svgScreen),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: seatData.seats.length,
              itemBuilder: (context, index) {
                return buildSeatRow(
                    seatData.seats[index], index + 1, rowLabels);
              },
            ),
          ),
        ],
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
              bool isSelectable = seatStatus != 1 && seatStatus != 2;
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
                    print(selectedSeats);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : seatColor,
                    borderRadius: BorderRadius.circular(2),
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

Widget renderBooking(BuildContext context, String theaterName, int roomNumber,
    Future<MovieDetail> movieInfo) {
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
        FutureBuilder<MovieDetail>(
          future: movieInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingData(context);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final movieData = snapshot.data!;
              return Container(
                margin: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
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
                                      height: 70,
                                      width: 50,
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 2.0),
                                        decoration: BoxDecoration(
                                          color: ClassifyClass.toFlutterColor(
                                            ClassifyClass.classifyType(
                                                movieData.classify),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(1.5),
                                        child: Text(
                                          movieData.classify,
                                          style: AppStyle.classifyText,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        movieData.title,
                                        style: AppStyle.smallText,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    movieData.country,
                                    style: AppStyle.smallText,
                                  ),
                                  Text(
                                    '${movieData.duration.toString()} minutes',
                                    style: AppStyle.smallText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Theater: $theaterName',
                                style: AppStyle.smallText),
                            Text('Room: $roomNumber',
                                style: AppStyle.smallText),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        const Text.rich(
          TextSpan(
            text: 'TOTAL: ',
            style: AppStyle.bodyText1,
            children: <TextSpan>[
              TextSpan(
                text: '${100000000}',
                style: AppStyle.bodyText1,
              ),
              TextSpan(
                text: '\$',
                style: AppStyle.bodyText1,
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {},
            child: const Text(
              'BOOKING',
              style: AppStyle.buttonNavigator,
            ),
          ),
        ),
      ],
    ),
  );
}
