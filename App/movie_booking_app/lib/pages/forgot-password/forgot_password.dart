import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
import 'package:movie_booking_app/services/Users/forgotpassword/forgot_password.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: Common.customAppbar(
          context, null, null, '', AppColors.appbarColor, null),
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
                        ShowDialog.showLoadingDialog(context);
                        bool result =
                            await ForgotPasswordService.forgotPassword(
                                email, context);
                        if (!result && !valid.isValidEmail(email, context)) {
                          Navigator.pop(context);
                          return;
                        }
                        valid.showMessage(
                            context,
                            AppLocalizations.of(context)!.otp_send,
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
                        debugPrint('invalid send otp: $error');
                      }
                    },
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.tieptuc,
                            style: const TextStyle(
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
