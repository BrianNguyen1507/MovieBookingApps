import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movie_ticket_scanner/Converter/convert.dart';
import 'package:movie_ticket_scanner/model/order.dart';

class WidgetForm {
  static Widget buildTicketInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTicketInfo(Result order) {
    return Column(
      children: [
        const Text(
          'THÔNG TIN VÉ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Colors.blue.withOpacity(0.3),
          ),
          child: Column(
            children: [
              Tooltip(
                message: order.address ?? 'N/A',
                child: WidgetForm.buildTicketInfoRow(
                    'RẠP:', order.theaterName ?? 'N/A'),
              ),
              WidgetForm.buildTicketInfoRow('PHÒNG CHIẾU:',
                  order.roomNumber == 0 ? 'N/A' : 'Room ${order.roomNumber}'),
              WidgetForm.buildTicketInfoRow(
                  'LỊCH CHIẾU:',
                  order.movieSchedule != null
                      ? ConverterData.formatToDmY(order.movieSchedule!.date)
                      : 'N/A'),
              WidgetForm.buildTicketInfoRow(
                  'GIỜ CHIẾU:',
                  order.movieSchedule != null
                      ? '${order.movieSchedule!.timeStart} - ${order.movieSchedule!.timeEnd}'
                      : 'N/A'),
              WidgetForm.buildTicketInfoRow('VỊ TRÍ:', order.seat ?? 'N/A'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildMovieInfo(context, Result order) {
    return Column(
      children: [
        const Text(
          'THÔNG TIN PHIM',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        if (order.movieSchedule != null && order.movieSchedule!.film != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.black.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<Uint8List>(
                  future: ConverterData.bytesToImage(
                      order.movieSchedule!.film!.poster),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: Image.memory(
                          snapshot.data!,
                          height: 90,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return const Text('No movie available');
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        maxLines: 2,
                        order.movieSchedule!.film!.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${order.movieSchedule!.film!.duration} Phút',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ConverterData.formatToDmY(
                          order.movieSchedule!.film!.releaseDate),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          const Text('No movie available',
              style: TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }

  static Widget buildFoodInfo(Result order) {
    return Column(
      children: [
        const Text(
          'THÔNG TIN THỨC ĂN',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Colors.green.withOpacity(0.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.foods != null && order.foods!.isNotEmpty
                ? order.foods!.map((food) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Số lượng: x${food.quantity}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Đơn giá: ${ConverterData.formatPrice(food.price)}đ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList()
                : [const Text('No food available')],
          ),
        ),
      ],
    );
  }
}
