import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
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
  void setState(VoidCallback fn) {
    futureFoodOrder = FoodOrderService.getAllFoodOrder();
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderResponse>>(
      future: futureFoodOrder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingContent,
          );
        } else if (snapshot.data == null) {
          return const Center(
            child: Text(
              "Ticket list is empty",
              style: TextStyle(
                fontSize: AppFontSize.medium,
              ),
            ),
          );
        } else {
          List<OrderResponse> foodOrders = snapshot.data!;
          return SizedBox(
            height: foodOrders.length * 75,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
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
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: AppColors.containerColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: AppColors.shadowColor,
                            offset: Offset(2, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.4),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          margin: const EdgeInsets.all(5.0),
                          child: const Column(
                            children: [
                              ClipRRect(
                                child: Icon(
                                  Icons.fastfood,
                                  color: AppColors.textblackColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "Date order: ${ConverterUnit.formatDMYhm(foodOder.date!)}",
                                  style: const TextStyle(
                                      fontSize: AppFontSize.small),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "Payment: ${foodOder.paymentMethod}",
                                  style: const TextStyle(
                                      fontSize: AppFontSize.small),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox.shrink(),
                              Text(
                                foodOder.status,
                                style: TextStyle(
                                    fontSize: AppFontSize.small,
                                    fontWeight: FontWeight.bold,
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
        }
      },
    );
  }
}
