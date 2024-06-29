import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/schedule/schedule.dart'; // Assuming Schedule and ScheduleByHour are defined here

Widget buildScheduleList(Schedule schedule, BuildContext context) {
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
      return buildScheduleWidget(roomNumber, schedules);
    },
  );
}

Widget buildScheduleWidget(int roomNumber, List<ScheduleByHour> schedules) {
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
          child: Text(
            'ROOM: $roomNumber',
            style: AppStyle.bodyText1,
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
              return ScheduleButton(schedule: schedules[index]);
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

  const ScheduleButton({super.key, required this.schedule});

  @override
  State<ScheduleButton> createState() => _ScheduleButtonState();
}

class _ScheduleButtonState extends State<ScheduleButton> {
  bool isSelected = false;
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
