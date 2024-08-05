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
  List<OrderResponse>? foodOrders;

  @override
  void initState() {
    super.initState();
    futureFoodOrder = FoodOrderService.getAllFoodOrder(context);
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
          return Center(child: progressLoading);
        } else {
          foodOrders = snapshot.data!;
          return SizedBox(
            height: AppSize.height(context) - 96,
            child: ListView.builder(
                itemCount: foodOrders!.length,
                itemBuilder: (context, index) {
                  final fooditem = foodOrders![index];

                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.containerColor,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: AppColors.shadowColor,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailOrderPage(
                              key: widget.key,
                              id: fooditem.id.toInt(),
                            ),
                          ),
                        );
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.only(right: 10.0),
                        child: const Icon(
                          Icons.fastfood,
                          color: AppColors.textblackColor,
                          size: 50,
                        ),
                      ),
                      title: Text(
                        "${AppLocalizations.of(context)!.date_order}: ${ConverterUnit.formatDMYhm(fooditem.date!)}",
                        style: const TextStyle(fontSize: AppFontSize.small),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.payment_med}: ${fooditem.paymentMethod}",
                            style: const TextStyle(fontSize: AppFontSize.small),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: fooditem.status == "Unused"
                                      ? AppColors.correctColor
                                      : fooditem.status == "Expired"
                                          ? AppColors.errorColor
                                          : AppColors.grayTextColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    fooditem.status == "Unused"
                                        ? ''
                                        : fooditem.status == "Expired"
                                            ? AppLocalizations.of(context)!
                                                .expired
                                            : AppLocalizations.of(context)!
                                                .used,
                                    style: AppStyle.classifyText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.pay_success,
                                    style: AppStyle.classifyText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
      },
    );
  }

  bool get wantKeepAlive => true;
}
