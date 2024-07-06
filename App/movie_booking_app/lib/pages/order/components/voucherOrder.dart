import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/voucher/voucherApply.dart';
import 'package:movie_booking_app/services/Users/voucher/voucherService.dart';

// ignore: must_be_immutable
class VoucherOrder extends StatefulWidget {
  VoucherOrder({super.key, required this.total});
  double total;

  @override
  State<VoucherOrder> createState() => _VoucherOrderState();
}

class _VoucherOrderState extends State<VoucherOrder> {
  late Future<List<Voucher>> voucherData;
  bool isChecked = false;
  int? selectedVoucherIndex;
  Preferences pref = Preferences();
  @override
  void initState() {
    super.initState();
    loadVoucherData();
  }

  void loadVoucherData() async {
    voucherData = VoucherService.getAllVoucherByAccount(widget.total);
    final voucherId = await pref.getVoucher();
    print(voucherId);

    setState(() {
      selectedVoucherIndex = voucherId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: AppColors.commonLightColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              iconColor: AppColors.backgroundColor,
              elevation: 0.0,
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.commonLightColor,
            ),
            onPressed: () => Navigator.pop(context),
            child: Icon(AppIcon.close),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: voucherData,
              builder: (context, AsyncSnapshot<List<Voucher>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingContent);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final vouchers = snapshot.data!;

                  return ListView.builder(
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      return Opacity(
                        opacity: vouchers[index].allowed ? 1.0 : 0.5,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (vouchers[index].allowed) {
                                  if (selectedVoucherIndex ==
                                      vouchers[index].id) {
                                    selectedVoucherIndex = null;
                                  } else {
                                    selectedVoucherIndex = vouchers[index].id;
                                  }
                                } else {
                                  selectedVoucherIndex = null;
                                }
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Card(
                                child: SizedBox(
                                  child: ListTile(
                                    leading: SvgPicture.string(
                                      svgVoucherCard,
                                      height: 50,
                                      width: 50,
                                    ),
                                    title: Text(
                                      utf8.decode(
                                        vouchers[index].title.codeUnits,
                                      ),
                                      style: AppStyle.detailText,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          utf8.decode(
                                            vouchers[index].content.codeUnits,
                                          ),
                                          style: AppStyle.smallText,
                                        ),
                                        Text(
                                          'Lowest price: ${ConverterUnit.formatPrice(vouchers[index].minLimit)}₫',
                                          style: AppStyle.smallText,
                                        ),
                                        Text(
                                          'Discount: ${vouchers[index].discount}',
                                          style: AppStyle.smallText,
                                        ),
                                        Text(
                                          'Expired: ${vouchers[index].expired}',
                                          style: AppStyle.smallText,
                                        ),
                                      ],
                                    ),
                                    trailing: Checkbox(
                                      activeColor: AppColors.primaryColor,
                                      shape: const CircleBorder(),
                                      value: selectedVoucherIndex ==
                                          vouchers[index].id,
                                      onChanged: vouchers[index].allowed
                                          ? (bool? value) {
                                              setState(() {
                                                if (value!) {
                                                  selectedVoucherIndex =
                                                      vouchers[index].id;
                                                } else {
                                                  selectedVoucherIndex = null;
                                                }
                                              });
                                            }
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child:
                renderApplyVoucher(context, selectedVoucherIndex, widget.total),
          )
        ],
      ),
    );
  }

  Widget renderApplyVoucher(
      BuildContext context, int? selectedVocher, double total) {
    return Column(
      children: [
        SizedBox(
          width: AppSize.width(context),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () async {
              if (selectedVocher == null) {
                return;
              }
              pref.saveSVoucher(selectedVoucherIndex = selectedVocher);
              double totalApplyed =
                  await VoucherApply.applyVoucher(selectedVocher, total);
              //update total vua apply voucher
              Navigator.pop(context,
                  {'newTotal': totalApplyed, 'voucherId': selectedVocher});
            },
            child: const Text(
              'APPLY',
              style: AppStyle.buttonNavigator,
            ),
          ),
        ),
      ],
    );
  }
}
