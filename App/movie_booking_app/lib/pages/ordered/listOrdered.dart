import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/pages/ordered/listFilmOrder.dart';

class ListOrdered extends StatefulWidget {
  const ListOrdered({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListOrderedState();
  }
}

class ListOrderedState extends State<ListOrdered> {
  bool isTabSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Ordered"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTabSelected = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: isTabSelected ? 2.0 : 0,
                          ),
                        ),
                      ),
                      width: AppSize.width(context) / 2,
                      child: Text(
                        "List Film Order ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFontSize.medium,
                          fontWeight:
                              isTabSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTabSelected = false;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: isTabSelected ? 0 : 2,
                          ),
                        ),
                      ),
                      width: AppSize.width(context) / 2,
                      child: Text(
                        "List Food Order ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFontSize.medium,
                          fontWeight:
                              isTabSelected ? FontWeight.normal : FontWeight.bold,
                        ),
                      )),
                ),
              ],
            ),
            Builder(builder: (context) {
              return const Listfilmorder();
            },)
          ],
        ),
      ),
    );
  }
}
