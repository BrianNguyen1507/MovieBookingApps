import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/schedule/schedule.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/selection/components/schedulewidget/scheduleWidget.dart';
import 'package:movie_booking_app/services/Users/schedule/scheduleService.dart';

class ScheduleSelection extends StatefulWidget {
  final int movieId;
  final String theaterName;
  final int theaterId;
  const ScheduleSelection(
      {super.key,
      required this.theaterName,
      required this.theaterId,
      required this.movieId});

  @override
  State<ScheduleSelection> createState() => _ScheduleSelectionState();
}

late Future<Schedule?> scheduleData;

class _ScheduleSelectionState extends State<ScheduleSelection> {
  String dateformated = ConverterUnit.convertToDate(DateTime.now().toString());
  @override
  void initState() {
    scheduleData = ScheduleService.getAllSchedule(
      dateformated,
      widget.theaterId,
      widget.movieId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.commonLightColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.containerColor,
        ),
        title: Text(
          widget.theaterName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        titleTextStyle: AppStyle.bannerText,
      ),
      body: Column(
        children: [
          SizedBox(
            child: DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: AppColors.primaryColor,
              daysCount: 7,
              width: 60,
              height: 90,
              locale: "vi_VN",
              onDateChange: (date) {
                setState(
                  () {
                    dateformated = ConverterUnit.convertToDate(date.toString());
                    scheduleData = ScheduleService.getAllSchedule(
                        dateformated, widget.theaterId, widget.movieId);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Schedule?>(
              future: scheduleData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingContent);
                } else if (snapshot.hasError) {
                  return Center(child: loadingContent);
                } else if (snapshot.data == null) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: const Text(
                        'Oops! There are no schedules available. Please come back later.'),
                  );
                } else {
                  final scheduleSnapshot = snapshot.data!;
                  return buildScheduleList(scheduleSnapshot, context,
                      widget.theaterName, widget.movieId);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
