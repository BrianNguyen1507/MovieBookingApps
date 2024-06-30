import 'package:flutter/material.dart';
import 'package:movie_booking_app/models/order/Total.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.total});
  final GetTotal total;
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    print(widget.total.total);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
