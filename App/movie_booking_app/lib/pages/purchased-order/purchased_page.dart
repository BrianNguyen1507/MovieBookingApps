import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/pages/purchased-order/list_film_order.dart';
import 'package:movie_booking_app/pages/purchased-order/list_food_order.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOrdered extends StatefulWidget {
  const ListOrdered({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListOrderedState();
  }
}

class ListOrderedState extends State<ListOrdered> {
  bool isTabSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.containerColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.my_orders),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: AppStyle.bannerText,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.containerColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.containerColor,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTabSelected = true;
                      });
                    },
                    child: Container(
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isTabSelected
                              ? AppColors.primaryColor.withOpacity(0.3)
                              : AppColors.transpanrent,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primaryColor,
                              width: isTabSelected ? 2.0 : 0,
                            ),
                          ),
                        ),
                        width: AppSize.width(context) / 2,
                        child: Text(AppLocalizations.of(context)!.movie_tickets,
                            textAlign: TextAlign.center,
                            style: AppStyle.bodyText1)),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTabSelected = false;
                      });
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isTabSelected
                            ? AppColors.transpanrent
                            : AppColors.primaryColor.withOpacity(0.3),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primaryColor,
                            width: isTabSelected ? 0 : 2,
                          ),
                        ),
                      ),
                      width: AppSize.width(context) / 2,
                      child: Text(AppLocalizations.of(context)!.food_tickets,
                          textAlign: TextAlign.center,
                          style: AppStyle.bodyText1),
                    ),
                  ),
                ],
              ),
              isTabSelected ? const ListFilmOrder() : const ListFoodOrder()
            ],
          ),
        ),
      ),
    );
  }
}
