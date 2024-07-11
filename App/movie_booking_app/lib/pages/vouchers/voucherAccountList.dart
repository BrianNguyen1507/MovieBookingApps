import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/services/Users/voucher/voucherService.dart';

class VoucherAccountList extends StatefulWidget {
  const VoucherAccountList({super.key});

  @override
  State<VoucherAccountList> createState() => _VoucherAccountListState();
}

class _VoucherAccountListState extends State<VoucherAccountList> {
  late Future<List<Voucher>> myVoucher;

  @override
  void initState() {
    myVoucher = VoucherService.getVoucherByEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.iconThemeColor),
        backgroundColor: AppColors.appbarColor,
        title: const Text(
          'My Vouchers List',
          style: AppStyle.headline2,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Voucher>>(
          future: myVoucher,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingData(context);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final listVoucher = snapshot.data!;
              return SizedBox(
                height: listVoucher.length * 150,
                child: ListView.builder(
                  itemCount: listVoucher.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                        'Lowest price: ${ConverterUnit.formatPrice(listVoucher[index].minLimit)}₫',
                                        style: AppStyle.smallText,
                                      ),
                                      Text(
                                        'Discount: ${listVoucher[index].discount}',
                                        style: AppStyle.smallText,
                                      ),
                                      Text(
                                        'Expired: ${listVoucher[index].expired}',
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
              );
            }
          },
        ),
      ),
    );
  }
}
