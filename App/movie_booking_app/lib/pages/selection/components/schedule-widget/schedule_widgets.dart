import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/svg_string.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/schedule/schedule.dart';
import 'package:movie_booking_app/pages/selection/seat_selection.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildScheduleList(
  Schedule schedule,
  BuildContext context,
  String theaterName,
  int movieId,
  String date,
) {
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
      return buildScheduleWidget(
          roomNumber, schedules, theaterName, movieId, date);
    },
  );
}

Widget buildScheduleWidget(int roomNumber, List<ScheduleByHour> schedules,
    String theaterName, int movieId, String date) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(boxShadow: const [
      BoxShadow(
        blurRadius: 6.0,
        color: AppColors.shadowColor,
        offset: Offset(2, 1),
      ),
    ], color: AppColors.containerColor, borderRadius: ContainerRadius.radius12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: ContainerRadius.radius10,
            color: AppColors.containerColor,
          ),
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: AppColors.commonLightColor,
                    borderRadius: ContainerRadius.radius5,
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
                date: date,
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
  final String date;
  const ScheduleButton({
    super.key,
    required this.schedule,
    required this.theaterName,
    required this.movieId,
    required this.date,
  });

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
      onTap: () async {
        setState(() {
          isSelected = !isSelected;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isSelected = false;
          });
        });
        Preferences pref = Preferences();
        pref.saveSchedule(widget.schedule.id);
        int? prefid = await pref.getSchedule();
        debugPrint('PREF schedule ID: $prefid');
        debugPrint('Selected schedule: ${widget.schedule.id}');
        debugPrint('Selected schedule: ${widget.schedule.times}');
        debugPrint('Selected schedule: ${widget.schedule.roomNumber}');
        if (token == null) {
          ShowDialog.showAlertCustom(
              context,
              AppLocalizations.of(context)!.sigin_noti,
              AppLocalizations.of(context)!.go_signin,
              true, () {
            Navigator.pushNamed(context, '/login');
          }, DialogType.question);

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
              date: widget.date,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: ContainerRadius.radius5,
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
