import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/models/theater/theater.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/selection/components/theater_widget/theater_widget.dart';
import 'package:movie_booking_app/services/Users/theater/theater_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';

class TheaterSelection extends StatefulWidget {
  final int movieId;
  final String name;
  const TheaterSelection(
      {super.key, required this.movieId, required this.name});

  @override
  State<TheaterSelection> createState() => _TheaterSelectionState();
}

late Future<List<Theater>?> listTheater;

class _TheaterSelectionState extends State<TheaterSelection> {
  @override
  void initState() {
    super.initState();
    listTheater = GetAllMovieTheater.getAllMovieTheater(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.customAppbar(context, null, AppStyle.headline2,
          widget.name, AppColors.iconThemeColor, AppColors.appbarColor),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.commonLightColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(borderRadius: ContainerRadius.radius10),
              child: Row(
                children: [
                  SizedBox(
                    width: AppSize.width(context) / 2,
                    child: Text(
                      AppLocalizations.of(context)!.branch_cinema,
                      style: AppStyle.bodyText1,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: listTheater,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingData(context);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No theaters found',
                      style: TextStyle(color: AppColors.primaryColor),
                    ));
                  } else {
                    List<Theater> theaters = snapshot.data!;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: theaters.length,
                      itemBuilder: (context, index) {
                        return TheaterItems.theaterTag(
                          context,
                          theaters,
                          index,
                          widget.movieId,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
