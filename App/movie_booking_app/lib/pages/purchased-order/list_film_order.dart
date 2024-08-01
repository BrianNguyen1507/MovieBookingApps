import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/order_movie_response.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/purchased-order/detail_order_page.dart';
import 'package:movie_booking_app/provider/consumer/translator.dart';
import 'package:movie_booking_app/services/Users/puchased/get_all_movies.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListFilmOrder extends StatefulWidget {
  const ListFilmOrder({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListFilmOrderState();
  }
}

class ListFilmOrderState extends State<ListFilmOrder> {
  late Future<List<OrderResponse>?> futureFilmOrder;

  @override
  void initState() {
    futureFilmOrder = FilmOrder.getAllFilmOrder(context);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    futureFilmOrder = FilmOrder.getAllFilmOrder(context);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderResponse>?>(
      future: futureFilmOrder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: progressLoading);
        } else if (snapshot.data == null ||
            !snapshot.hasData ||
            snapshot.hasError) {
          return progressLoading;
        } else {
          List<OrderResponse> filmOrders = snapshot.data!;
          return SizedBox(
            height: AppSize.height(context) - 100,
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
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    width: AppSize.width(context),
                    height: 120,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: AppColors.shadowColor,
                            offset: Offset(2, 1),
                          ),
                        ],
                        color: AppColors.containerColor,
                        borderRadius: ContainerRadius.radius12),
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
                                      borderRadius: ContainerRadius.radius5,
                                      child: Image.memory(
                                          ConverterUnit.base64ToUnit8(
                                              filmOrder.poster)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: AppSize.width(context) / 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: TranslateConsumer()
                                          .translateProvider(
                                              filmOrder.title,
                                              1,
                                              AppStyle.bodyText1),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.date_order}: ${ConverterUnit.formatDMYhm(filmOrder.date!)}",
                                      style: const TextStyle(
                                          fontSize: AppFontSize.small),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.payment_med}: ${filmOrder.paymentMethod}",
                                      style: const TextStyle(
                                          fontSize: AppFontSize.small),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                          color:
                                              filmOrder.status == "Unused"
                                                  ? AppColors.correctColor
                                                  : AppColors.errorColor,
                                          borderRadius:
                                              ContainerRadius.radius2,
                                        ),
                                        child: Center(
                                          child: Text(
                                            filmOrder.status == "Unused"
                                                ? ''
                                                : AppLocalizations.of(
                                                        context)!
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
                                          borderRadius:
                                              ContainerRadius.radius2,
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
