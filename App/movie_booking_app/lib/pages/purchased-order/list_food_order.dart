import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/order_movie_response.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/purchased-order/detail_order_page.dart';
import 'package:movie_booking_app/services/Users/puchased/get_all_foods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListFoodOrder extends StatefulWidget {
  const ListFoodOrder({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListFoodOrderState();
  }
}

class ListFoodOrderState extends State<ListFoodOrder> {
  late Future<List<OrderResponse>?> futureFoodOrder;

  @override
  void initState() {
    futureFoodOrder = FoodOrderService.getAllFoodOrder(context);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    futureFoodOrder = FoodOrderService.getAllFoodOrder(context);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderResponse>?>(
      future: futureFoodOrder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: progressLoading);
        } else if (snapshot.data == null ||
            snapshot.hasError ||
            !snapshot.hasData) {
          return progressLoading;
        } else {
          List<OrderResponse> foodOrders = snapshot.data!;
          return SizedBox(
            height: AppSize.height(context) - 100,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: foodOrders.length,
              itemBuilder: (context, index) {
                OrderResponse foodOder = foodOrders[index];
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailOrderPage(
                            key: widget.key,
                            id: foodOder.id.toInt(),
                          ),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: AppColors.containerColor,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: AppColors.shadowColor,
                            offset: Offset(2, 1),
                          ),
                        ],
                        borderRadius: ContainerRadius.radius12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.4),
                              borderRadius: ContainerRadius.radius12),
                          margin: const EdgeInsets.all(5.0),
                          child: const Column(
                            children: [
                              ClipRRect(
                                child: Icon(
                                  Icons.fastfood,
                                  color: AppColors.textblackColor,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "${AppLocalizations.of(context)!.date_order}: ${ConverterUnit.formatDMYhm(foodOder.date!)}",
                                  style: const TextStyle(
                                      fontSize: AppFontSize.small),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "${AppLocalizations.of(context)!.payment_med}:  ${foodOder.paymentMethod}",
                                  style: const TextStyle(
                                      fontSize: AppFontSize.small),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      color: foodOder.status == "Unused"
                                          ? AppColors.correctColor
                                          : AppColors.errorColor,
                                      borderRadius: ContainerRadius.radius2,
                                    ),
                                    child: Center(
                                      child: Text(
                                        foodOder.status == "Unused"
                                            ? ''
                                            : AppLocalizations.of(context)!
                                                .expired,
                                        style: AppStyle.classifyText,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(3.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: ContainerRadius.radius2,
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .pay_success,
                                        style: AppStyle.classifyText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
