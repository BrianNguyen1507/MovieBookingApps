import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/order/Total.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildBottomSheetOrder(
  BuildContext context,
  GetTotal total,
  String seats,
  List<Map<String, dynamic>> foods,
  double newTotal,
  double? discount,
  bool visible,
) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Expanded(
          flex: 7,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.order_detail,
                style: AppStyle.headline1,
              ),
              visible
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.seats}:',
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
                    )
                  : const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.fnd}:',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.discount}:',
                    style: AppStyle.bodyText1,
                  ),
                  Text(
                    '- ${ConverterUnit.formatPrice(discount!)}₫',
                    style: AppStyle.graySmallText,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.total}:',
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
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: AppSize.width(context),
              decoration: BoxDecoration(
                borderRadius: ContainerRadius.radius20,
                color: AppColors.commonColor,
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: AppStyle.buttonText2,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
