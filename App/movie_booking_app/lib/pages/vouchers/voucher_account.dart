import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/vouchers/components/voucher_invalid.dart';
import 'package:movie_booking_app/services/Users/voucher/voucher_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.iconThemeColor),
        backgroundColor: AppColors.appbarColor,
        title: Text(
          AppLocalizations.of(context)!.my_vouchers,
          style: AppStyle.headline2,
        ),
      ),
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
                          return Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  color: AppColors.shadowColor,
                                  offset: Offset(0.1, 0.2),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
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
                                              listVoucher[index].content,
                                              style: AppStyle.smallText,
                                            ),
                                            Text(
                                              '${AppLocalizations.of(context)!.condition}: ${ConverterUnit.formatPrice(listVoucher[index].minLimit)}₫',
                                              style: AppStyle.smallText,
                                            ),
                                            Text(
                                              '${AppLocalizations.of(context)!.discount}: ${listVoucher[index].discount}',
                                              style: AppStyle.smallText,
                                            ),
                                            Text(
                                              '${AppLocalizations.of(context)!.date_expired}: ${listVoucher[index].expired}',
                                              style: AppStyle.smallText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
