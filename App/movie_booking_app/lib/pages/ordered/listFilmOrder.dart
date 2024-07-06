import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/ordered/detailOrderPage.dart';
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
  void setState(VoidCallback fn) {
  futureFilmOrder = FilmOrder.getAllFilmOrder();
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderResponse>>(
      future: futureFilmOrder,
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
          List<OrderResponse> filmOrders = snapshot.data!;
          return SizedBox(
            height: filmOrders.length * 110,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filmOrders.length,
              itemBuilder: (context, index) {
                OrderResponse filmOrder = filmOrders[index];
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailOrderPage(
                            key: widget.key,
                            id: filmOrder.id.toInt(),
                          ),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                    width: AppSize.width(context),
                    height: 100,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: AppColors.shadowColor,
                            offset: Offset(2, 1),
                          ),
                        ],
                        color: AppColors.containerColor,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      child: Image.memory(
                                          ConverterUnit.base64ToUnit8(
                                              filmOrder.poster)),
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    color: filmOrder.status == "Unused"
                                        ? AppColors.backgroundColor
                                            .withOpacity(0.1)
                                        : AppColors.backgroundColor
                                            .withOpacity(0.5),
                                    child: Center(
                                      child: Text(
                                        filmOrder.status == "Unused"
                                            ? ''
                                            : filmOrder.status,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppFontSize.small,
                                            color: filmOrder.status == "Unused"
                                                ? AppColors.correctColor
                                                : AppColors.commonLightColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text("Movie: ${filmOrder.title}",
                                        style: AppStyle.bodyText1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Date order: ${ConverterUnit.formatDMYhm(filmOrder.date!)}",
                                      style: const TextStyle(
                                          fontSize: AppFontSize.small),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "Payment: ${filmOrder.paymentMethod}",
                                      style: const TextStyle(
                                          fontSize: AppFontSize.small),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
