import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/ordered/DetailOrder.dart';
import 'package:movie_booking_app/pages/ordered/QrcodePage.dart';
import 'package:movie_booking_app/pages/ratingfeedback/ratingfeedback.dart';

Widget detailOrderFilm(BuildContext context, DetailOrder order) {
  return Container(
    margin: const EdgeInsets.all(15.0),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      color: AppColors.containerColor,
    ),
    width: AppSize.width(context),
    child: Column(
      children: [
        order.order.status == "Used"
            ? Container(
                padding: const EdgeInsets.all(5.0),
                width: AppSize.width(context),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RatingFeedbackPage(order: order.order),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: const Text(
                    "Rating",
                    style: AppStyle.headline2,
                  ),
                ),
              )
            : const SizedBox(
                width: 0,
              ),
        Center(
          child: order.order.status == "Unused"
              ? const SizedBox.shrink()
              : Text(
                  order.order.status,
                  style: AppStyle.bigText,
                ),
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              color: AppColors.primaryColor.withOpacity(0.2)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: AppColors.containerColor.withOpacity(0.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                            height: 100,
                            ConverterUnit.base64ToUnit8(order.order.poster)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ClassifyClass.toFlutterColor(
                                    ClassifyClass.classifyType(
                                        order.order.classify),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(3.0),
                                  ),
                                ),
                                child: Text(
                                  order.order.classify,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.containerColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  " ${order.order.title}",
                                  style: AppStyle.titleMovie,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Duration: ${order.order.duration} minute",
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Languge: ${order.order.language}",
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              child: const Text("Order code",
                                  style: AppStyle.graySmallText),
                            ),
                            Text(
                              order.order.paymentCode,
                              style: AppStyle.priceText,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              child: const Text("Show time",
                                  style: AppStyle.graySmallText),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${ConverterUnit.formatHM(order.movieTimeStart!)} - ${ConverterUnit.formatHM(order.movieTimeEnd!)}',
                                  style: AppStyle.showTimeText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QrcodePage(qr: order.orderCode),
                          )),
                      child: Center(
                        child: Image.memory(
                          ConverterUnit.base64ToUnit8(order.orderCode),
                          width: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Show this code to the staff to get movie tickets',
                style: AppStyle.smallText,
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: AppColors.primaryColor.withOpacity(0.2)),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('CINEMA', style: AppStyle.bodyText1),
                        Text(order.theaterName, style: AppStyle.headline1),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Room', style: AppStyle.thinText),
                            Text('Room ${order.roomNumber.toString()}',
                                style: AppStyle.blackBold),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Tickets', style: AppStyle.thinText),
                            Text(
                                (ConverterUnit.convertStringToSet(order.seat)
                                        .length)
                                    .toString(),
                                style: AppStyle.blackBold),
                          ],
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Seats', style: AppStyle.thinText),
                              Text(order.seat, style: AppStyle.blackBold),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("FOOD & DRINK", style: AppStyle.bodyText1),
                      ),
                    ),
                    const Divider(),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: order.food.isEmpty
                          ? 45
                          : (45 * order.food.length).toDouble(),
                      child: order.food.isEmpty
                          ? const Text(
                              "No food ordered",
                              style: AppStyle.smallText,
                            )
                          : ListView.builder(
                              itemCount: order.food.length,
                              itemBuilder: (context, index) {
                                Food food = order.food[index];
                                return Container(
                                  margin: const EdgeInsets.all(8),
                                  width: AppSize.width(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        food.name,
                                        style: const TextStyle(
                                            fontSize: AppFontSize.small),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${ConverterUnit.formatPrice(food.price)} x ",
                                            style: const TextStyle(
                                                fontSize: AppFontSize.small),
                                          ),
                                          Text(
                                            "${food.quantity}",
                                            style: const TextStyle(
                                                fontSize: AppFontSize.small),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: AppColors.grayTextColor.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    const Text("PAYMENT", style: AppStyle.bodyText1),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Payment Method",
                              style: AppStyle.thinText,
                            ),
                            Text(order.order.paymentMethod,
                                style: AppStyle.blackBold),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: AppStyle.thinText,
                            ),
                            Text(
                                "${ConverterUnit.formatPrice(order.order.sumTotal)}₫",
                                style: AppStyle.headline1),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget detailOrderFood(BuildContext context, DetailOrder order) {
  return SizedBox(
    height: AppSize.height(context),
    child: Container(
      margin: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: AppColors.containerColor,
      ),
      width: AppSize.width(context),
      child: Column(
        children: [
          Center(
            child: order.order.status == "Unused"
                ? const SizedBox.shrink()
                : Text(
                    order.order.status,
                    style: AppStyle.bigText,
                  ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        child: const Text("Order code",
                            style: AppStyle.graySmallText),
                      ),
                      Text(
                        order.order.paymentCode,
                        style: AppStyle.priceText,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrcodePage(qr: order.orderCode),
                        )),
                    child: Center(
                      child: Image.memory(
                        ConverterUnit.base64ToUnit8(order.orderCode),
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("FOOD & DRINK", style: AppStyle.bodyText1),
                      ),
                    ),
                    const Divider(),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: order.food.isEmpty
                          ? 45
                          : (45 * order.food.length).toDouble(),
                      child: order.food.isEmpty
                          ? const Text(
                              "No food ordered",
                              style: AppStyle.smallText,
                            )
                          : ListView.builder(
                              itemCount: order.food.length,
                              itemBuilder: (context, index) {
                                Food food = order.food[index];
                                return Container(
                                  margin: const EdgeInsets.all(8),
                                  width: AppSize.width(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        food.name,
                                        style: const TextStyle(
                                            fontSize: AppFontSize.small),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${ConverterUnit.formatPrice(food.price)} x ",
                                            style: const TextStyle(
                                                fontSize: AppFontSize.small),
                                          ),
                                          Text(
                                            "${food.quantity}",
                                            style: const TextStyle(
                                                fontSize: AppFontSize.small),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: AppColors.grayTextColor.withOpacity(0.2),
                  ),
                  child: Column(
                    children: [
                      const Text("PAYMENT", style: AppStyle.bodyText1),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Payment Method",
                                style: AppStyle.thinText,
                              ),
                              Text(order.order.paymentMethod,
                                  style: AppStyle.blackBold),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: AppStyle.thinText,
                              ),
                              Text(
                                  "${ConverterUnit.formatPrice(order.order.sumTotal)}₫",
                                  style: AppStyle.headline1),
                            ],
                          ),
                        ],
                      ),
                    ],
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
