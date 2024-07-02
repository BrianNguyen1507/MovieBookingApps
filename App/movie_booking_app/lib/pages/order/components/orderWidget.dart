import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/order/Total.dart';

Widget buildBottomSheetOrder(GetTotal total, String seats,
    List<Map<String, dynamic>> foods, double newTotal) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        const Text(
          'Orders Details',
          style: AppStyle.headline1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Seats:',
              style: AppStyle.bodyText1,
            ),
            Row(
              children: [
                Text(
                  '(x${ConverterUnit.convertStringToSet(seats).length}) ',
                  style: AppStyle.smallText,
                ),
                Text(
                  '${ConverterUnit.formatPrice(total.priceMovie)}₫',
                  style: AppStyle.graySmallText,
                ),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Food and Drinks:',
              style: AppStyle.bodyText1,
            ),
            Row(
              children: [
                Text(
                  '(x${foods.length}) ',
                  style: AppStyle.smallText,
                ),
                Text(
                  '${ConverterUnit.formatPrice(total.priceFood!)}₫',
                  style: AppStyle.graySmallText,
                ),
              ],
            )
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total:',
              style: AppStyle.bodyText1,
            ),
            Text(
              '${ConverterUnit.formatPrice(newTotal)}₫',
              style: AppStyle.bodyText1,
            ),
          ],
        ),
      ],
    ),
  );
}
