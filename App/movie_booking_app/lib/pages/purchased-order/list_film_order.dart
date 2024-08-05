import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/ordered/order_movie_response.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/purchased-order/detail_order_page.dart';
import 'package:movie_booking_app/services/Users/puchased/get_all_movies.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListFilmOrder extends StatefulWidget {
  const ListFilmOrder({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListFilmOrderState();
  }
}

class ListFilmOrderState extends State<ListFilmOrder>
    with AutomaticKeepAliveClientMixin {
  late Future<List<OrderResponse>?> futureFilmOrder;
  List<OrderResponse>? filmOrders;
  List<OrderResponse>? filmOrderCache;

  @override
  void initState() {
    super.initState();
    if (filmOrderCache == null) {
      futureFilmOrder = FilmOrder.getAllFilmOrder(context);
    } else {
      futureFilmOrder = Future.value(filmOrderCache);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: FutureBuilder<List<OrderResponse>?>(
        future: futureFilmOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: progressLoading);
          } else if (snapshot.data == null ||
              !snapshot.hasData ||
              snapshot.hasError) {
            return Center(child: progressLoading);
          } else {
            filmOrders = snapshot.data!;
            filmOrderCache = filmOrders;
            return SizedBox(
              height: AppSize.height(context) - 106,
              child: ListView.builder(
                itemCount: filmOrderCache!.length,
                itemBuilder: (context, index) {
                  final filmOrder = filmOrderCache![index];
                  return Container(
                    key: ValueKey(filmOrder.id),
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.containerColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
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
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(
                          width: 50,
                          ConverterUnit.getImageFromCache(filmOrder.poster),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      title: Text(
                        filmOrder.title,
                        maxLines: 2,
                        style: AppStyle.bodyText1,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.date_order}: ${ConverterUnit.formatDMYhm(filmOrder.date!)}",
                            style: const TextStyle(fontSize: AppFontSize.small),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.payment_med}: ${filmOrder.paymentMethod}",
                            style: const TextStyle(fontSize: AppFontSize.small),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: filmOrder.status == "Unused"
                                      ? AppColors.correctColor
                                      : filmOrder.status == "Expired"
                                          ? AppColors.errorColor
                                          : AppColors.grayTextColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    filmOrder.status == "Unused"
                                        ? ''
                                        : filmOrder.status == "Expired"
                                            ? AppLocalizations.of(context)!
                                                .expired
                                            : AppLocalizations.of(context)!
                                                .used,
                                    style: AppStyle.classifyText,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(3.0),
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
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
