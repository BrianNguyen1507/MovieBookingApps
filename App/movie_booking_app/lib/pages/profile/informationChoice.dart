import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/pages/profile/updateInformation.dart';

class InformationChoice extends StatelessWidget{
  const InformationChoice({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information"),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: const TextStyle(
          color: AppColors.titleTextColor,
          fontSize: AppFontSize.midMedium,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 100 , left: 10,right: 10),
        width: AppSize.width(context),
        child: Column(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: AppFontSize.medium,
                  color: Colors.black
                ),
              ),

              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateInformation(),));
              },
              child: SizedBox(
                width: AppSize.width(context),
                height: 50,
                child: Row(
                  children: [
                    const Text(
                        "Update Information",
                    ),
                    const Expanded(child: SizedBox()),
                    Icon(AppIcon.arrowR),
                  ],
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: AppFontSize.medium,
                    color: Colors.black
                ),
              ),

              onPressed: () {
                print("haha");
              },
              child: SizedBox(
                width: AppSize.width(context),
                height: 50,
                child: Row(
                  children: [
                    const Text(
                      "Change password",
                    ),
                    const Expanded(child: SizedBox()),
                    Icon(AppIcon.arrowR),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}