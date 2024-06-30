import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/schedule/schedule.dart';
import 'package:movie_booking_app/pages/selection/seatSelection.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

Widget buildScheduleList(
    Schedule schedule, BuildContext context, String theaterName, int movieId) {
  Map<int, List<ScheduleByHour>> groupedSchedules = {};

  for (var scheduleByHour in schedule.scheduleByHour) {
    if (!groupedSchedules.containsKey(scheduleByHour.roomNumber)) {
      groupedSchedules[scheduleByHour.roomNumber] = [];
    }
    groupedSchedules[scheduleByHour.roomNumber]!.add(scheduleByHour);
  }
  return ListView.builder(
    padding: const EdgeInsets.all(5.0),
    itemCount: groupedSchedules.length,
    itemBuilder: (context, index) {
      int roomNumber = groupedSchedules.keys.elementAt(index);
      List<ScheduleByHour> schedules = groupedSchedules[roomNumber]!;
      return buildScheduleWidget(roomNumber, schedules, theaterName, movieId);
    },
  );
}

Widget buildScheduleWidget(int roomNumber, List<ScheduleByHour> schedules,
    String theaterName, int movieId) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.all(5.0),
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          blurRadius: 6.0,
          color: AppColors.shadowColor,
          offset: Offset(2, 1),
        ),
      ],
      color: AppColors.containerColor,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: AppColors.containerColor,
          ),
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: AppColors.commonLightColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    border: Border.all(width: 0.5)),
                height: 30,
                width: 30,
                child: SvgPicture.string(svgCinema),
              ),
              Text(
                'ROOM: $roomNumber',
                style: AppStyle.bodyText1,
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.commonColor,
        ),
        SizedBox(
          height: fitHeight(schedules.length, 5, 50, 5.0, 5.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 10 / 6,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              return ScheduleButton(
                schedule: schedules[index],
                theaterName: theaterName,
                movieId: movieId,
              );
            },
          ),
        ),
      ],
    ),
  );
}

double fitHeight(int itemCount, int crossAxisCount, double itemHeight,
    double crossAxisSpacing, double mainAxisSpacing) {
  int rowCount = (itemCount / crossAxisCount).ceil();
  double totalHeight = rowCount * itemHeight + (rowCount - 1) * mainAxisSpacing;
  return totalHeight;
}

class ScheduleButton extends StatefulWidget {
  final ScheduleByHour schedule;
  final String theaterName;
  final int movieId;
  const ScheduleButton(
      {super.key,
      required this.schedule,
      required this.theaterName,
      required this.movieId});

  @override
  State<ScheduleButton> createState() => _ScheduleButtonState();
}

class _ScheduleButtonState extends State<ScheduleButton> {
  bool isSelected = false;
  dynamic token;
  Preferences pref = Preferences();

  @override
  void initState() {
    super.initState();
    _initToken();
  }

  Future<void> _initToken() async {
    token = await pref.getTokenUsers();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isSelected = false;
          });
        });

        print('Selected schedule: ${widget.schedule.id}');
        print('Selected schedule: ${widget.schedule.times}');
        print('Selected schedule: ${widget.schedule.roomNumber}');
        if (token == null) {
          ValidInput valid = ValidInput();
          valid.showAlertCustom(
              context, 'You need to sign in to continue', 'Go to Sign in', () {
            Navigator.pushNamed(context, '/login');
          });

          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeatSelection(
              time: widget.schedule.times,
              scheduleId: widget.schedule.id,
              roomNumber: widget.schedule.roomNumber,
              theaterName: widget.theaterName,
              movieId: widget.movieId,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color:
              isSelected ? AppColors.primaryColor : AppColors.commonDarkColor,
        ),
        child: Center(
          child: Text(
            ConverterUnit.formatTimeToHhmm(widget.schedule.times),
            style: AppStyle.timerText,
          ),
        ),
      ),
    );
  }
}
