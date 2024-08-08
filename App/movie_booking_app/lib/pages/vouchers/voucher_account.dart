import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/vouchers/components/voucher_invalid.dart';
import 'package:movie_booking_app/pages/vouchers/voucher_detail.dart';
import 'package:movie_booking_app/services/Users/voucher/voucher_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';

class VoucherAccountList extends StatefulWidget {
  const VoucherAccountList({super.key});

  @override
  State<VoucherAccountList> createState() => _VoucherAccountListState();
}

class _VoucherAccountListState extends State<VoucherAccountList> {
  late Future<List<Voucher>?> myVoucher;

  @override
  void initState() {
    myVoucher = VoucherService.getVoucherByEmail(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.commonLightColor,
      appBar: Common.customAppbar(
          context,null,
          AppStyle.headline2,
          AppLocalizations.of(context)!.my_vouchers,
          AppColors.iconThemeColor,
          AppColors.appbarColor),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Voucher>?>(
          future: myVoucher,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return progressLoading;
            } else if (snapshot.hasError || !snapshot.hasData) {
              return progressLoading;
            } else {
              final listVoucher = snapshot.data!;
              return listVoucher.isNotEmpty
                  ? SizedBox(
                      height: listVoucher.length * 200,
                      child: ListView.builder(
                        itemCount: listVoucher.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return VoucherDetail(
                                          voucher: listVoucher[index],
                                        );
                                      },
                                    ));
                                  },
                                  child: Card(
                                    color: AppColors.containerColor,
                                    child: SizedBox(
                                      child: ListTile(
                                        leading: SvgPicture.asset(
                                          'assets/svg/discount-voucher.svg',
                                          height: 50,
                                          width: 50,
                                        ),
                                        title: Text(
                                          listVoucher[index].title,
                                          style: AppStyle.detailText,
                                          maxLines: 2,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.condition}: ${ConverterUnit.formatPrice(listVoucher[index].minLimit)}₫',
                                              style: AppStyle.smallText,
                                            ),
                                            Text(
                                              '${AppLocalizations.of(context)!.discount}: ${listVoucher[index].discount} ${VoucherData.unitPrice(listVoucher[index].typeDiscount)}',
                                              style: AppStyle.smallText,
                                            ),
                                            Text(
                                              '${AppLocalizations.of(context)!.date_expired}: ${ConverterUnit.formatToDmY(listVoucher[index].expired)}',
                                              style: AppStyle.smallText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : vouchersInvalid(context);
            }
          },
        ),
      ),
    );
  }
}
