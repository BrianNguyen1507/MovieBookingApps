import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_data.dart';

void showBookingSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Stack(
            children: [
              const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        'Order details:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ProductDetail(
                          name: 'Product 1', quantity: 2, price: 29.99),
                      ProductDetail(
                          name: 'Product 2', quantity: 1, price: 59.99),
                      ProductDetail(
                          name: 'Product 3', quantity: 3, price: 19.99),

                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(AppIcon.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ProductDetail extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;

  const ProductDetail({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Qty: $quantity',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
