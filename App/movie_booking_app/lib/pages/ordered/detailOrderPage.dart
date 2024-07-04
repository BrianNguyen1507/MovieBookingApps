import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/ordered/DetailOrder.dart';
import 'package:movie_booking_app/pages/ordered/QrcodePage.dart';
import 'package:movie_booking_app/services/Users/ordered/detailOrderService.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({super.key, required this.id});

  final int id;

  @override
  State<StatefulWidget> createState() {
    return DetailOrderPageState();
  }
}

class DetailOrderPageState extends State<DetailOrderPage> {
  late Future<DetailOrder> orderFuture;

  @override
  void initState() {
    super.initState();
    orderFuture = DetailOrderService.detailOrder(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Order"),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: AppFontSize.medium,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<DetailOrder>(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                width: AppSize.width(context),
                height: AppSize.height(context),
                child: const Center(child: CircularProgressIndicator()));
          } else if (!snapshot.hasData) {
            return const Text('No data available'); // Handle no data case
          }
          DetailOrder order = snapshot.data!;
          return SingleChildScrollView(
              child: order.seat.isNotEmpty
                  ? detailOrderFilm(order)
                  : detailOrderFood(order));
        },
      ),
    );
  }

  Widget detailOrderFilm(DetailOrder order) {
    return SizedBox(
      width: AppSize.width(context),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrcodePage(qr: order.orderCode),
                )),
            child: Center(
              child: Image.memory(
                ConverterUnit.base64ToUnit8(order.orderCode),
                width: 250,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              order.theaterName,
              style: const TextStyle(
                fontSize: AppFontSize.midMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Room ${order.roomNumber}",
              style: const TextStyle(
                fontSize: AppFontSize.midMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  ConverterUnit.formatDMY(order.movieTimeStart!),
                  style: const TextStyle(
                    fontSize: AppFontSize.medium,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: [
                Text(
                  ConverterUnit.formatHM(order.movieTimeStart!),
                  style: const TextStyle(
                    fontSize: AppFontSize.big,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                Text(
                  "- ${ConverterUnit.formatHM(order.movieTimeEnd!)}",
                  style: const TextStyle(
                    fontSize: AppFontSize.midMedium,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                Text(
                  order.seat,
                  style: const TextStyle(
                    fontSize: AppFontSize.midMedium,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: AppSize.width(context) - 100,
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                        ConverterUnit.base64ToUnit8(order.order.poster)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          " ${order.order.title}",
                          style: const TextStyle(fontSize: AppFontSize.small),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          " Duration: ${order.order.duration} minute",
                          style: const TextStyle(fontSize: AppFontSize.small),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          " Release Date: ${ConverterUnit.formatToDmY(order.order.releaseDate)}",
                          style: const TextStyle(fontSize: AppFontSize.small),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: ClassifyClass.toFlutterColor(
                            ClassifyClass.classifyType(order.order.classify),
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3.0),
                          ),
                        ),
                        child: Text(
                          order.order.classify,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.containerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8),
                width: AppSize.width(context) - 50,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.black))),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Food",
                    style: TextStyle(fontSize: AppFontSize.lowMedium),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.all(10),
                height: order.food.isEmpty
                    ? 45
                    : (45 * order.food.length).toDouble(),
                child: order.food.isEmpty
                    ? const Text(
                        "Not order food",
                        style: TextStyle(fontSize: AppFontSize.lowMedium),
                      )
                    : ListView.builder(
                        itemCount: order.food.length,
                        itemBuilder: (context, index) {
                          Food food = order.food[index];
                          return Container(
                            margin: const EdgeInsets.all(8),
                            width: AppSize.width(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                      fontSize: AppFontSize.small),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${ConverterUnit.formatPrice(food.price)} x ",
                                      style: const TextStyle(
                                          fontSize: AppFontSize.small),
                                    ),
                                    Text(
                                      "${food.quantity}",
                                      style: const TextStyle(
                                          fontSize: AppFontSize.small),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          SizedBox(
            width: AppSize.width(context) - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8),
                  width: AppSize.width(context) - 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 2, color: Colors.black))),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Voucher",
                      style: TextStyle(fontSize: AppFontSize.lowMedium),
                    ),
                  ),
                ),
                order.voucherTitle == ""
                    ? const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Not apply voucher",
                          style: TextStyle(fontSize: AppFontSize.lowMedium),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              order.voucherTitle,
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "${ConverterUnit.formatPrice(order.discount)} ${order.typeDiscount == 0 ? "đ" : "%"}",
                              style:
                                  const TextStyle(fontSize: AppFontSize.small),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          SizedBox(
            width: AppSize.width(context) - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8),
                  width: AppSize.width(context) - 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 2, color: Colors.black))),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Payment",
                      style: TextStyle(fontSize: AppFontSize.lowMedium),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(3.0),
                      child: const Text(
                        "Payment Code",
                        style: TextStyle(fontSize: AppFontSize.small),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        order.order.paymentCode,
                        style: const TextStyle(fontSize: AppFontSize.small),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(3.0),
                      child: const Text(
                        "Payment Method",
                        style: TextStyle(fontSize: AppFontSize.small),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        order.order.paymentMethod,
                        style: const TextStyle(fontSize: AppFontSize.small),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: AppSize.width(context) - 50,
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 2, color: Colors.black))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: AppFontSize.medium),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "${ConverterUnit.formatPrice(order.order.sumTotal)} đ",
                    style: const TextStyle(fontSize: AppFontSize.medium),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget detailOrderFood(DetailOrder order) {
    return Column(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrcodePage(qr: order.orderCode),
                  )),
              child: Center(
                child: Image.memory(
                  ConverterUnit.base64ToUnit8(order.orderCode),
                  width: 250,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8),
              width: AppSize.width(context) - 50,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2, color: Colors.black))),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Food",
                  style: TextStyle(fontSize: AppFontSize.lowMedium),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(10),
              height:
                  order.food.isEmpty ? 45 : (45 * order.food.length).toDouble(),
              child: order.food.isEmpty
                  ? const Text(
                      "Not order food",
                      style: TextStyle(fontSize: AppFontSize.lowMedium),
                    )
                  : ListView.builder(
                      itemCount: order.food.length,
                      itemBuilder: (context, index) {
                        Food food = order.food[index];
                        return Container(
                          margin: const EdgeInsets.all(8),
                          width: AppSize.width(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                    fontSize: AppFontSize.small),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${ConverterUnit.formatPrice(food.price)} x ",
                                    style: const TextStyle(
                                        fontSize: AppFontSize.small),
                                  ),
                                  Text(
                                    "${food.quantity}",
                                    style: const TextStyle(
                                        fontSize: AppFontSize.small),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        SizedBox(
          width: AppSize.width(context) - 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8),
                width: AppSize.width(context) - 50,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.black))),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Voucher",
                    style: TextStyle(fontSize: AppFontSize.lowMedium),
                  ),
                ),
              ),
              order.voucherTitle == ""
                  ? const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Not apply voucher",
                        style: TextStyle(fontSize: AppFontSize.lowMedium),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            order.voucherTitle,
                            style: const TextStyle(fontSize: AppFontSize.small),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${ConverterUnit.formatPrice(order.discount)} ${order.typeDiscount == 0 ? "đ" : "%"}",
                            style: const TextStyle(fontSize: AppFontSize.small),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        SizedBox(
          width: AppSize.width(context) - 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8),
                width: AppSize.width(context) - 50,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.black))),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Payment",
                    style: TextStyle(fontSize: AppFontSize.lowMedium),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    padding: const EdgeInsets.all(3.0),
                    child: const Text(
                      "Payment Code",
                      style: TextStyle(fontSize: AppFontSize.small),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      order.order.paymentCode,
                      style: const TextStyle(fontSize: AppFontSize.small),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    padding: const EdgeInsets.all(3.0),
                    child: const Text(
                      "Payment Method",
                      style: TextStyle(fontSize: AppFontSize.small),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      order.order.paymentMethod,
                      style: const TextStyle(fontSize: AppFontSize.small),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: AppSize.width(context) - 50,
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 2, color: Colors.black))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontSize: AppFontSize.medium),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "${ConverterUnit.formatPrice(order.order.sumTotal)} đ",
                  style: const TextStyle(fontSize: AppFontSize.medium),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
