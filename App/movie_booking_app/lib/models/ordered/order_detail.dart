import 'package:movie_booking_app/models/food/food.dart';

import 'order_movie_response.dart';

class DetailOrder{
    OrderResponse order;
    bool allowedComment;
    String voucherTitle;
    int typeDiscount;
    double discount;
    List<Food> food;
    String theaterName;
    int roomNumber;
    DateTime? movieTimeStart;
    DateTime? movieTimeEnd;
    String orderCode;
    String seat;


    DetailOrder({
        required this.order,
        required this.allowedComment,
        required this.voucherTitle,
        required this.food,
        required this.theaterName,
        required this.roomNumber,
        required this.movieTimeStart,
        required this.orderCode,
        required this.movieTimeEnd,
        required this.typeDiscount,
        required this.discount,
        required this.seat,

    });
    factory DetailOrder.fromJson(Map<String,dynamic>json){
        OrderResponse order = OrderResponse(
            id: BigInt.from(json['id']),
            sumTotal: (json['sumTotal'] as num).toDouble(),
            date: json['date'] != null ? DateTime.parse(json['date']) : null,
            paymentMethod: json['paymentMethod'],
            poster: json['film'] == null ? "" : json['film']['poster'],
            title: json['film'] == null ? "" : json['film']['title'],
            duration: json['film'] == null ? 0 : (json['film']['duration'] as num).toInt(),
            classify: json['film'] == null ? "" : json['film']['classify'],
            language: json['film'] == null ? "" : json['film']['language'],
            releaseDate: json['film'] == null ? "" : json['film']['releaseDate'],
            status: json['status'],
            paymentCode: json['paymentCode'],
        );
        List<Food> foods = [];
        var foodJson = json['food'];

            for(var item in foodJson){
                Food food = Food.fromJson(item);
                foods.add(food);
            }

        String voucherTitle =  json['voucher']==null?"":json['voucher']['title'];
        int typeDiscount = json['voucher']==null?0:(json['voucher']['typeDiscount']as num).toInt();
        double discount = json['voucher']==null?0:(json['voucher']['discount']as num).toDouble();
        String theaterName = json['theaterName']??"";
        int roomNumber = json['roomNumber']??0;
        DateTime? movieTimeStart = json['movieTimeStart']!=null?DateTime.parse(json['movieTimeStart']):null;
        DateTime? movieTimeEnd = json['movieTimeEnd']!=null?DateTime.parse(json['movieTimeEnd']):null;
        String orderCode = json['orderCode'];
        String seat = json['seat']??"";
        bool allowedComment = json['allowedComment'];

        return DetailOrder(
            order: order,
            allowedComment: allowedComment,
            voucherTitle: voucherTitle,
            food: foods,
            theaterName: theaterName,
            roomNumber: roomNumber,
            movieTimeStart: movieTimeStart,
            orderCode: orderCode,
            movieTimeEnd: movieTimeEnd,
            typeDiscount: typeDiscount,
            discount: discount,
            seat: seat,
        );
    }

}