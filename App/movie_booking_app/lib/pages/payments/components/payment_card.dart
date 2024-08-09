import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/pages/order/order_page.dart';
import 'package:movie_booking_app/services/Users/order/hold-seat/hold_seat_service.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';

class PaymentCard extends StatelessWidget {
  final bool visible;
  final int sumtotal;
  final String? seats;
  final List<Map<String, dynamic>> foods;
  final Function handlePayment;
  final String methodName;
  final String methodIcon;

  const PaymentCard({
    super.key,
    required this.visible,
    required this.sumtotal,
    required this.seats,
    required this.foods,
    required this.handlePayment,
    required this.methodName,
    required this.methodIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Tooltip(
        message: 'Payment via $methodName',
        child: GestureDetector(
          onTap: () async {
            int amount = sumtotal;
            if (amount < 1000 || amount > 1000000) {
              ValidInput()
                  .showMessage(context, 'Invalid amount', AppColors.errorColor);
            } else {
              debugPrint('TONG TIEN LA: $sumtotal');
              showModalBottomSheet(
                context: context,
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: MaterialButton(
                    onPressed: () async {
                      final int? scheduleId = await pref.getSchedule();
                      bool isValid = await HoldSeatService.checkHoldSeat(
                          context, scheduleId, seats);
                      if (visible && !isValid) {
                        ShowDialog.showAlertCustom(
                          context,
                          true,
                          'Some seats have been selected, please choose another seat',
                          null,
                          true,
                          null,
                          DialogType.error,
                        );
                      } else {
                        await handlePayment();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${AppLocalizations.of(context)!.open} $methodName',
                          style: AppStyle.buttonText2,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    methodIcon,
                    height: 70,
                    width: 70,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Text(
                methodName,
                style: AppStyle.titleMovie,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
