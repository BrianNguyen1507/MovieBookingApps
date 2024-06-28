import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/pages/googlemap/googleMap.dart';

class TheaterSelection extends StatefulWidget {
  const TheaterSelection({super.key});

  @override
  State<TheaterSelection> createState() => _TheaterSelectionState();
}

class _TheaterSelectionState extends State<TheaterSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.containerColor,
        ),
        title: const Text('MOVIE NAME'),
        titleTextStyle: AppStyle.bannerText,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: AppSize.width(context) / 2,
                    child: const Text(
                      'Cinema branch',
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
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: AppSize.width(context),
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: AppColors.containerColor,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: AppColors.shadowColor,
                              offset: Offset(2, 1),
                            ),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.all(5.0),
                                    child: SvgPicture.string(svgTheater),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: AppSize.width(context) * 0.5,
                                        child: const Text(
                                          'Cinema Ward 888888888888888888888888888888',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyle.titleTheater,
                                        ),
                                      ),
                                      SizedBox(
                                        width: AppSize.width(context) * 0.5,
                                        child: const Text(
                                          'Cinema Ward 1aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaádadadasdaaaaaaaaa',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyle.smallText,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const FractionallySizedBox(
                                        child: MapTheater(),
                                      );
                                    },
                                  );
                                },
                                child: SizedBox(
                                  child: SizedBox(
                                    width: 30.0,
                                    height: 30.0,
                                    child: SvgPicture.string(
                                      svgMap,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
