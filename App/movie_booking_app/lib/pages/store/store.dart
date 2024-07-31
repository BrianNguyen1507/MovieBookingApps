import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/order/get_total.dart';
import 'package:movie_booking_app/modules/timer/timer.dart';
import 'package:movie_booking_app/pages/order/order_page.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/services/Users/food/food_service.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/services/Users/order/hold-seat/hold_seat_service.dart';
import 'package:movie_booking_app/services/Users/order/get-total/get_total_service.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  final int scheduleId;
  final int movieId;
  final Set<String>? seats;
  final String? date;
  final String? theater;
  final int? room;
  final String? schedule;
  final bool selection;
  const StorePage({
    super.key,
    required this.selection,
    this.seats,
    required this.movieId,
    required this.scheduleId,
    this.theater,
    this.schedule,
    this.date,
    this.room,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late Future<List<Food>?> foods;
  late List<TextEditingController> _controllers;
  late List<int> _values;
  late List<Map<String, dynamic>> foodOrder;
  Preferences pref = Preferences();
//call lai khi an nut
  late Future<GetTotal> getTotal;
  late String? seats;
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    foods = FoodService.getAllFood(context);
    _controllers = [];
    _values = [];
    foodOrder = [];
    final fetchedSeats = await pref.getHoldSeats();
    if (mounted) {
      setState(() {
        seats = fetchedSeats;
        debugPrint(' seat in store $seats');
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _incrementValue(int index) {
    setState(() {
      _values[index]++;
      _controllers[index].text = _values[index].toString();
      foodOrder[index]['quantity'] = _values[index];
    });
  }

  void _decrementValue(int index) {
    if (_values[index] > 0) {
      setState(() {
        _values[index]--;
        _controllers[index].text = _values[index].toString();
        foodOrder[index]['quantity'] = _values[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.fnd,
                      style: AppStyle.headline1),
                  widget.selection
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.backgroundColor,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Food>?>(
                future: foods,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: loadingContent);
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: loadingContent,
                    );
                  } else {
                    final foodData = snapshot.data!;

                    if (_controllers.isEmpty && _values.isEmpty) {
                      _controllers = List.generate(
                        foodData.length,
                        (index) => TextEditingController(text: '0'),
                      );
                      _values = List.generate(foodData.length, (index) => 0);
                      foodOrder = List.generate(
                        foodData.length,
                        (index) => {
                          'id': foodData[index].id,
                          'quantity': 0,
                        },
                      );
                    }

                    return ListView.builder(
                      itemCount: foodData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: AppColors.containerColor,
                              borderRadius: ContainerRadius.radius5),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: ContainerRadius.radius12,
                                      ),
                                      margin: const EdgeInsets.only(right: 5.0),
                                      height: 60,
                                      width: 60,
                                      child: Image.memory(
                                        ConverterUnit.base64ToUnit8(
                                            foodData[index].image),
                                        height: 150,
                                        width: 100,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: AppSize.width(context) * 0.4,
                                            child: Consumer<ThemeProvider>(
                                              builder: (context, value, child) {
                                                return FutureBuilder(
                                                  future: value.translateText(
                                                      foodData[index].name),
                                                  builder: (context, snapshot) {
                                                    final nameTrans =
                                                        snapshot.data;
                                                    return Text(
                                                      maxLines: 3,
                                                      nameTrans ??
                                                          foodData[index].name,
                                                      style: AppStyle.bodyText1,
                                                    );
                                                  },
                                                );
                                              },
                                            )),
                                        SizedBox(
                                          width: AppSize.width(context) * 0.4,
                                          child: Row(
                                            children: [
                                              Text(
                                                maxLines: 1,
                                                '${AppLocalizations.of(context)!.price}: ',
                                                style: AppStyle.smallText,
                                              ),
                                              Text(
                                                maxLines: 1,
                                                '${ConverterUnit.formatPrice(foodData[index].price)} ₫',
                                                style: AppStyle.priceText,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: TextField(
                                        controller: _controllers[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _values[index] = int.parse(value);
                                            foodOrder[index]['quantity'] =
                                                _values[index];
                                          });
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () =>
                                              _incrementValue(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () =>
                                              _decrementValue(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            renderBooking(
                context,
                widget.selection,
                widget.date ?? DateTime.now().toString(),
                widget.theater ?? '',
                widget.schedule ?? '',
                widget.seats ?? {},
                widget.movieId,
                widget.scheduleId,
                foodOrder,
                widget.selection),
          ],
        ),
      ),
    );
  }
}

Widget renderBooking(
  context,
  bool visible,
  String selectedDate,
  String selectedTheater,
  String selectedSchedule,
  Set<String>? seats,
  int movieId,
  int scheduleId,
  List<Map<String, dynamic>> foodOrder,
  selection,
) {
  return Container(
    color: Colors.transparent,
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    width: double.infinity,
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: ContainerRadius.radius10),
          backgroundColor: AppColors.primaryColor,
        ),
        onPressed: () async {
          Preferences pref = Preferences();
          String? token = await pref.getTokenUsers();
          if (token == null) {
            ValidInput valid = ValidInput();
            valid.showAlertCustom(context, 'You need to sign in to continue',
                'Go to Sign in', true, () {
              Navigator.pushNamed(context, '/login');
            });
            return;
          }

          List<Map<String, dynamic>> listOrdered = [];
          for (var item in foodOrder) {
            if (item['quantity'] != 0) {
              listOrdered.add(item);
            }
          }

          if (!selection && listOrdered.isEmpty) {
            ValidInput val = ValidInput();
            val.showMessage(
                context,
                'Please choose at least one type of food and drink',
                Colors.red);
          } else {
            //set tg hold
            bool isSeatHold = visible
                ? await HoldSeatService.holdSeat(context, scheduleId, seats!)
                : false;
            pref.saveHoldSeats(seats!);

            isSeatHold ? TimerController.timerHoldSeatStart(context) : null;

            String? data = await pref.getHoldSeats();
            //
            debugPrint('Pref hold Seat:  $data');
            GetTotal? getTotal = await GetTotalService.sumTotalOrder(
                movieId, seats.length, listOrdered);
            //
            debugPrint('Store list:  $listOrdered');

            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return OrderPage(
                  total: getTotal,
                  movieId: movieId,
                  selectedDate: selectedDate,
                  selectedTheater: selectedTheater,
                  selectedSchedule: selectedSchedule,
                  selectedSeat: ConverterUnit.convertSetToString(seats),
                  visible: visible,
                  selectedFoods: listOrdered,
                );
              },
            ));
          }
        },
        child: Text(
          visible
              ? AppLocalizations.of(context)!.tieptuc
              : AppLocalizations.of(context)!.booking,
          style: AppStyle.buttonNavigator,
        ),
      ),
    ),
  );
}
