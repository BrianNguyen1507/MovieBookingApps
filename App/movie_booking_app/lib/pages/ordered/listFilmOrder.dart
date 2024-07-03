import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/DetailOrder.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/pages/ordered/detailOrderPage.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/ordered/detailOrderService.dart';
import 'package:movie_booking_app/services/Users/ordered/getAllFilmOrder.dart';

class ListFilmOrder extends StatefulWidget {
  const ListFilmOrder({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListFilmOrderState();
  }
}

class ListFilmOrderState extends State<ListFilmOrder> {
  late Future<List<OrderResponse>> futureFilmOrder;

  @override
  void initState() {
    futureFilmOrder = FilmOrder.getAllFilmOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderResponse>>(
      future: futureFilmOrder,
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
        List<OrderResponse> filmOrders = snapshot.data!;
        return SizedBox(
          width: AppSize.width(context),
          height: AppSize.height(context) - 160,
          child: ListView.builder(
            itemCount: filmOrders.length,
            itemBuilder: (context, index) {
              OrderResponse filmOrder = filmOrders[index];
              return GestureDetector(
                onTap: () async{
                  DetailOrder orderFuture =  await DetailOrderService.detailOrder(filmOrder.id.toInt());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailOrderPage(key:widget.key,id: filmOrder.id.toInt(),),));
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: AppSize.width(context),
                  height: 100,
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
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Image.memory(
                                ConverterUnit.base64ToUnit8(filmOrder.poster)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    " Film name: ${filmOrder.title}",
                                    style: const TextStyle(
                                        fontSize: AppFontSize.small),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    " Date order: ${ConverterUnit.formatDMYhm(filmOrder.date!)}",
                                    style: const TextStyle(
                                        fontSize: AppFontSize.small),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    " Payment Method: ${filmOrder.paymentMethod}",
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
                              ConverterUnit.formatPrice(filmOrder.sumTotal),
                              style: const TextStyle(
                                  fontSize: AppFontSize.small),
                            ),
                            Text(
                              filmOrder.status,
                              style:  TextStyle(
                                  fontSize: AppFontSize.small,
                                  color: filmOrder.status=="Unused"?AppColors.correctColor:AppColors.errorColor
                              ),
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
