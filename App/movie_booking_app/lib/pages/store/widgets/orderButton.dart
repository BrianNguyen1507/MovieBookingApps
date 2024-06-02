import 'package:flutter/material.dart';
import 'package:movie_booking_app/utils/bookingSheet.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  const DraggableFloatingActionButton({super.key});

  @override
  _DraggableFloatingActionButtonState createState() =>
      _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  double _left = 0;
  double _top = 0;
  double _previousLeft = 0;
  double _previousTop = 0;
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      final size = MediaQuery.of(context).size;
      _left = size.width - 60;
      _top = size.height - 180;
      _previousLeft = _left;
      _previousTop = _top;
      _isInitialized = true;
    }

    return Stack(
      children: [
        Positioned(
          left: _left,
          top: _top,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _left += details.delta.dx;
                _top += details.delta.dy;
              });
            },
            onPanEnd: (details) {
              final size = MediaQuery.of(context).size;
              const buttonSize = 56.0;

              if (_left < 0 ||
                  _left > size.width - buttonSize ||
                  _top < 0 ||
                  _top > size.height - buttonSize - 80) {
                setState(() {
                  _left = _previousLeft;
                  _top = _previousTop;
                });
              } else {
                _previousLeft = _left;
                _previousTop = _top;
              }
            },
            child: FloatingActionButton(
              onPressed: () {
                showBookingSheet(context);
                print("Floating Action Button Pressed");
              },
              child: const Icon(Icons.shopping_cart_rounded),
            ),
          ),
        ),
      ],
    );
  }
}
