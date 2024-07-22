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
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';
import 'package:movie_booking_app/services/Users/voucher/voucherApply.dart';
import 'package:movie_booking_app/services/Users/voucher/voucherService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    voucherData = VoucherService.getAllVoucherByAccount(context, widget.total);
    final voucherId = await pref.getVoucher();
    print(voucherId);

    setState(() {
      selectedVoucherIndex = voucherId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: AppColors.commonLightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: voucherData,
                      builder:
                          (context, AsyncSnapshot<List<Voucher>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: loadingContent);
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final vouchers = snapshot.data!;

                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                            selectedVoucherIndex =
                                                vouchers[index].id;
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
                                              vouchers[index].title,
                                              style: AppStyle.detailText,
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vouchers[index].content,
                                                  style: AppStyle.smallText,
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.condition}: ${ConverterUnit.formatPrice(vouchers[index].minLimit)}₫',
                                                  style: AppStyle.smallText,
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.discount}: ${vouchers[index].discount}',
                                                  style: AppStyle.smallText,
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.date_expired}: ${vouchers[index].expired}',
                                                  style: AppStyle.smallText,
                                                ),
                                              ],
                                            ),
                                            trailing: Checkbox(
                                              activeColor:
                                                  AppColors.primaryColor,
                                              shape: const CircleBorder(),
                                              value: selectedVoucherIndex ==
                                                  vouchers[index].id,
                                              onChanged: vouchers[index].allowed
                                                  ? (bool? value) {
                                                      setState(() {
                                                        if (value!) {
                                                          selectedVoucherIndex =
                                                              vouchers[index]
                                                                  .id;
                                                        } else {
                                                          selectedVoucherIndex =
                                                              null;
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
                  renderApplyVoucher(
                      context, selectedVoucherIndex, widget.total),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: Icon(AppIcon.close, color: AppColors.backgroundColor),
                onPressed: () => Navigator.pop(context),
                color: AppColors.commonDarkColor,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderApplyVoucher(context, int? selectedVocher, double total) {
    return Column(
      children: [
        SizedBox(
          width: AppSize.width(context),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: ContainerRadius.radius10,
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () async {
              if (selectedVocher == null) {
                ValidInput().showAlertCustom(context,
                    'Please select voucher to continue', '', true, null);
                return;
              }
              pref.saveSVoucher(selectedVoucherIndex = selectedVocher);
              double? totalApplyed = await VoucherApply.applyVoucher(
                  context, selectedVocher, total);
              //update total vua apply voucher
              Navigator.pop(context,
                  {'newTotal': totalApplyed, 'voucherId': selectedVocher});
            },
            child: Text(
              AppLocalizations.of(context)!.apply,
              style: AppStyle.buttonNavigator,
            ),
          ),
        ),
      ],
    );
  }
}
