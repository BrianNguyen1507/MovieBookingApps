import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/pages/movie-detail/components/detail_widgets.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VoucherDetail extends StatefulWidget {
  const VoucherDetail({super.key, required this.voucher});
  final Voucher voucher;
  @override
  State<VoucherDetail> createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Common.customAppbar(
          context,
          null,
          AppLocalizations.of(context)!.voucher_detail,
          AppColors.appbarColor,
          null),
      backgroundColor: AppColors.containerColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/svg/discount-voucher.svg',
              height: 100,
              width: 100,
            ),
            Text(
              widget.voucher.title,
              style: AppStyle.bodyText1,
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  detailContent(
                    AppLocalizations.of(context)!.condition,
                    '${ConverterUnit.formatPrice(widget.voucher.minLimit)}₫',
                  ),
                  detailContent(
                    AppLocalizations.of(context)!.discount,
                    '${widget.voucher.discount.toString()}${VoucherData.unitPrice(widget.voucher.typeDiscount)}',
                  ),
                  detailContent(
                    AppLocalizations.of(context)!.date_expired,
                    ConverterUnit.formatToDmY(widget.voucher.expired),
                  ),
                ],
              ),
            ),
            const Divider(),
            Text(
              widget.voucher.content,
              style: AppStyle.smallText,
            ),
          ],
        ),
      ),
    );
  }
}
