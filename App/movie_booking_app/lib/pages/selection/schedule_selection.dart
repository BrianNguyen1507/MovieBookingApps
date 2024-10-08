import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/schedule/schedule.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/selection/components/schedule-widget/schedule_invalid.dart';
import 'package:movie_booking_app/pages/selection/components/schedule-widget/schedule_widgets.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/services/Users/schedule/schedule_service.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:provider/provider.dart';

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
      context,
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
      appBar: Common.customAppbar(context, null, AppStyle.headline2,
          widget.theaterName, AppColors.iconThemeColor, AppColors.appbarColor),
      body: Column(
        children: [
          SizedBox(child: Consumer<ThemeProvider>(
            builder: (context, value, child) {
              bool locate = value.isEnglish;
              return DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: AppColors.primaryColor,
                daysCount: 7,
                width: 60,
                height: 90,
                locale: locate ? "en_EN" : "vi_VN",
                onDateChange: (date) {
                  setState(
                    () {
                      dateformated =
                          ConverterUnit.convertToDate(date.toString());
                      scheduleData = ScheduleService.getAllSchedule(context,
                          dateformated, widget.theaterId, widget.movieId);
                    },
                  );
                },
              );
            },
          )),
          Expanded(
            child: FutureBuilder<Schedule?>(
              future: scheduleData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingContent);
                } else if (snapshot.hasError) {
                  return Center(child: loadingContent);
                } else if (snapshot.data == null) {
                  return scheduleInvalid(context);
                } else {
                  final scheduleSnapshot = snapshot.data;
                  return buildScheduleList(scheduleSnapshot!, context,
                      widget.theaterName, widget.movieId, dateformated);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
