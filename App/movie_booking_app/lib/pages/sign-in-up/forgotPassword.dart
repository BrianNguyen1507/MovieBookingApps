import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
import 'package:movie_booking_app/services/Users/forgotpassword/forgotpassword.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({super.key});

  @override
  State<StatefulWidget> createState() {
    return ForgotPassWordState();
  }
}

class ForgotPassWordState extends State<ForgotPassWord> {
  TextEditingController emailController = TextEditingController();
  ValidInput valid = ValidInput();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "Forgot Password",
                style: TextStyle(
                    fontSize: AppFontSize.large,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: ContainerRadius.radius12),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.primaryColor, width: 2.0),
                        borderRadius: ContainerRadius.radius12),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                    ),
                    onPressed: () async {
                      String email = "";
                      setState(() {
                        email = emailController.text;
                      });
                      try {
                        showLoadingDialog(context);
                        bool result =
                            await ForgotPasswordService.forgotPassword(
                                email, context);
                        if (!result && !valid.isValidEmail(email, context)) {
                          Navigator.pop(context);
                          return;
                        }
                        valid.showMessage(
                            context,
                            'An OTP was send in your email.',
                            AppColors.correctColor);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPPage(
                              email: email,
                              method: AppStringMethod.forgotPassword,
                            ),
                          ),
                        );
                      } catch (error) {
                        valid.showMessage(
                            context, 'An error occurred', AppColors.errorColor);
                      }
                    },
                    child: const SizedBox(
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: AppFontSize.medium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
