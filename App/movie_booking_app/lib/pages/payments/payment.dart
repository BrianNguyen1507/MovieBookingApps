import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';

import 'package:movie_booking_app/services/Users/movieDetail/movieDetailService.dart';
import 'package:movie_booking_app/services/payments/ZaloPayService.dart';

class PaymentPage extends StatefulWidget {
  final double sumtotal;
  final bool visible;
  final String seats;
  final List<Map<String, dynamic>> foods;
  final String theater;
  final int movieId;
  final String time;
  final String date;

  const PaymentPage({
    super.key,
    required this.sumtotal,
    required this.visible,
    required this.seats,
    required this.foods,
    required this.theater,
    required this.time,
    required this.date,
    required this.movieId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const EventChannel eventChannel =
      EventChannel('flutter.native/eventPayOrder');
  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');
  late Future<MovieDetail> movieData;

  String zpTransToken = "";
  String payResult = "";
  int payAmount = 0;
  bool showResult = false;
  @override
  void initState() {
    widget.visible
        ? movieData = MovieDetailService.deatailMovieService(widget.movieId)
        : null;

    //zalo_init
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    payAmount = widget.sumtotal.toInt();

    super.initState();
  }

  void _onEvent(dynamic event) {
    print("_onEvent: '$event'.");
    Map<String, dynamic> res = Map<String, dynamic>.from(event);
    setState(() {
      if (res["errorCode"] == 1) {
        payResult = "Thanh toán thành công";
      } else if (res["errorCode"] == 4) {
        payResult = "User hủy thanh toán";
      } else {
        payResult = "Giao dịch thất bại";
      }
    });
  }

  void _onError(Object error) {
    print("_onError: '$error'.");
    setState(() {
      payResult = "Giao dịch thất bại";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'PAYMENTS',
          style: AppStyle.headline2,
        ),
        iconTheme: const IconThemeData(color: AppColors.containerColor),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: AppSize.height(context) * 0.9,
          decoration: const BoxDecoration(
            color: AppColors.commonLightColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.visible
                  ? FutureBuilder(
                      future: movieData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        } else if (snapshot.hasError) {
                          return loadingContent;
                        } else {
                          final getMovie = snapshot.data!;
                          return SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text('Movie Infomation',
                                      style: AppStyle.bodyText1),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  width: AppSize.width(context),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: AppColors.containerColor,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.memory(
                                              height: 90,
                                              width: 60,
                                              ConverterUnit.base64ToUnit8(
                                                  getMovie.poster)),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 2.0),
                                                decoration: BoxDecoration(
                                                  color: ClassifyClass
                                                      .toFlutterColor(
                                                    ClassifyClass.classifyType(
                                                        getMovie.classify),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(2),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(1.5),
                                                child: Text(
                                                  getMovie.classify,
                                                  style: AppStyle.classifyText,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                getMovie.title,
                                                style: AppStyle.titleOrder,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Categories: ${getMovie.categories.map((category) => category.name).join(', ')}',
                                            style: AppStyle.smallText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Duration: ${getMovie.duration.toString()} minutes',
                                            style: AppStyle.smallText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Country: ${getMovie.country.toString()}',
                                            style: AppStyle.smallText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Languge: ${getMovie.language.toString()}',
                                            style: AppStyle.smallText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                child: const Text(
                  'Payment Infomation',
                  style: AppStyle.bodyText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(15.0),
                width: AppSize.width(context),
                decoration: const BoxDecoration(
                  color: AppColors.containerColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.visible
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Theater: ',
                                  style: AppStyle.bodyText1),
                              Text(widget.theater,
                                  style: AppStyle.paymentInfoText),
                            ],
                          )
                        : const SizedBox.shrink(),
                    widget.visible
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Show time: ',
                                  style: AppStyle.bodyText1),
                              Text(
                                  '${ConverterUnit.formatToDmY(
                                    widget.visible
                                        ? widget.date
                                        : DateTime.now().toString(),
                                  )} | ${widget.time}',
                                  style: AppStyle.paymentInfoText),
                            ],
                          )
                        : const SizedBox.shrink(),
                    widget.visible
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Seats: ', style: AppStyle.bodyText1),
                              Text(widget.seats,
                                  style: AppStyle.paymentInfoText),
                            ],
                          )
                        : const SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Foods: ', style: AppStyle.bodyText1),
                        Text('x${widget.foods.length.toString()}',
                            style: AppStyle.paymentInfoText),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sum total: ', style: AppStyle.bodyText1),
                        Text(
                          '${ConverterUnit.formatPrice(widget.sumtotal)}₫',
                          style: AppStyle.headline1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Payment Methods',
                  style: AppStyle.bodyText1,
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      paymentCardWidget(payAmount),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentCardWidget(int sumtotal) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Tooltip(
        message: 'ZALO PAY',
        child: GestureDetector(
          onTap: () async {
            int amount = sumtotal;
            if (amount < 1000 || amount > 1000000) {
              setState(() {
                zpTransToken = "Invalid Amount";
                print(zpTransToken);
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: loadingData(context),
                  );
                },
              );
              var result = await createOrder(amount);
              if (result != null) {
                Navigator.pop(context);
                zpTransToken = result.zptranstoken;
                setState(() {
                  print('SUMTOTAL $sumtotal');
                  zpTransToken = result.zptranstoken;
                  showResult = true;
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await handlePayment();
                              },
                              child: const Text(
                                'OPEN ZALOPAY',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              }
            }
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/ZaloPay-vuong.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const Text(
                'ZALO PAY',
                style: AppStyle.titleMovie,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handlePayment() async {
    setState(() {
      payResult = "Processing...";
    });

    String response = "Processing...";
    try {
      final String result =
          await platform.invokeMethod('payOrder', {"zptoken": zpTransToken});
      response = result;
      print("Kết quả payOrder: '$result'.");
    } on PlatformException catch (e) {
      print("Gọi không thành công: '${e.message}'.");
      response = "Thanh toán thất bại";
    }

    setState(() {
      Navigator.pop(context);
      payResult = response;
      showResult = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              payResult == 'Payment failed'
                  ? SvgPicture.string(
                      svgError,
                      height: 100,
                      width: 100,
                    )
                  : SvgPicture.string(
                      svgSuccess,
                      height: 100,
                      width: 100,
                    ),
              Text(
                payResult,
                style: AppStyle.headline1,
              ),
            ],
          ),
        ),
      );
    });
  }
}
