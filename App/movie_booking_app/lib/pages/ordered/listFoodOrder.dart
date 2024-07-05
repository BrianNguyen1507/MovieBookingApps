import 'package:flutter/material.dart';

import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/pages/ordered/detailOrderPage.dart';
import 'package:movie_booking_app/services/Users/ordered/getAllFoodOrder.dart';

class ListFoodOrder extends StatefulWidget {
  const ListFoodOrder({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListFoodOrderState();
  }
}

class ListFoodOrderState extends State<ListFoodOrder> {
  late Future<List<OrderResponse>> futureFoodOrder;

  @override
  void initState() {
    futureFoodOrder = FoodOrderService.getAllFoodOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderResponse>>(
      future: futureFoodOrder,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
              child: Text(
            "Ticket list is empty",
            style: TextStyle(
              fontSize: AppFontSize.medium,
            ),
          ));
        }
        List<OrderResponse>? foodOrders = snapshot.data;
        return SizedBox(
          width: AppSize.width(context),
          height: AppSize.height(context),
          child: ListView.builder(
            itemCount: foodOrders?.length,
            itemBuilder: (context, index) {
              OrderResponse foodOder = foodOrders![index];
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
                  margin: const EdgeInsets.all(10),
                  width: AppSize.width(context),
                  height: AppSize.height(context) / 10,
                  decoration: BoxDecoration(
                      color: AppColors.commonLightColor,
                      border: Border.all(width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.fastfood,
                            size: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    " Date order: ${ConverterUnit.formatDMYhm(foodOder.date!)}",
                                    style: const TextStyle(
                                        fontSize: AppFontSize.small),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    " Payment Method: ${foodOder.paymentMethod}",
                                    style: const TextStyle(
                                        fontSize: AppFontSize.small),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ConverterUnit.formatPrice(foodOder.sumTotal),
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                            Text(
                              foodOder.status,
                              style: TextStyle(
                                  fontSize: AppFontSize.small,
                                  color: foodOder.status == "Unused"
                                      ? AppColors.correctColor
                                      : AppColors.errorColor),
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
      },
    );
  }
}
