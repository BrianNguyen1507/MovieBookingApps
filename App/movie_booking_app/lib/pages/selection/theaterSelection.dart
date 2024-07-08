import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/models/theater/theater.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/selection/components/theaterwidget/theaterItem.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/services/Users/theater/theaterService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TheaterSelection extends StatefulWidget {
  final int movieId;
  final String name;
  const TheaterSelection(
      {super.key, required this.movieId, required this.name});

  @override
  State<TheaterSelection> createState() => _TheaterSelectionState();
}

late Future<List<Theater>> listTheater;

class _TheaterSelectionState extends State<TheaterSelection> {
  @override
  void initState() {
    super.initState();
    listTheater = GetAllMovieTheater.getAllMovieTheater();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.containerColor,
        ),
        title: Consumer<ThemeProvider>(
          builder: (context, value, child) {
            return FutureBuilder<String>(
              future: value.translateText(widget.name),
              builder: (context, snapshot) {
                final titleTrans = snapshot.data ?? widget.name;
                return Text(
                  titleTrans,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            );
          },
        ),
        titleTextStyle: AppStyle.bannerText,
      ),
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
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                  Expanded(
                    child: DropdownButton<String>(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem<String>(
                            value: 'option1', child: Text('Option 1')),
                        DropdownMenuItem<String>(
                            value: 'option2', child: Text('Option 2')),
                      ],
                      onChanged: (value) {
                        setState(() {});
                      },
                      value: null,
                    ),
                  ),
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
