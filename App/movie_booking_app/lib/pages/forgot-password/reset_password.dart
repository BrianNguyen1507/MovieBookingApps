import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/pages/sign-in-up/sign_in_sign_up.dart';
import 'package:movie_booking_app/services/Users/forgotpassword/reset_password.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email, required this.otp});
  final dynamic email;
  final String otp;
  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPassword> {
  bool _obscureText = true;
  bool _obscureTextRef = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRefController = TextEditingController();
  ValidInput valid = ValidInput();
  String? email = "";
  String passwordWarning = "";
  String passwordMatch = "Password match";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.containerColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "Reset Password",
                style: TextStyle(
                    fontSize: AppFontSize.large,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                    child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.black),
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 3.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: ContainerRadius.radius10),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? AppIcon.visibleOff
                                : AppIcon.visibleOn,
                            color: _obscureText
                                ? Colors.grey
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: passwordRefController,
                          onChanged: (value) {
                            setState(() {
                              if (passwordRefController.text == "") {
                                passwordWarning = "";
                              } else {
                                passwordWarning = passwordController.text !=
                                        passwordRefController.text
                                    ? "Password do not match!"
                                    : passwordMatch;
                              }
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          obscureText: _obscureTextRef,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 3.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: ContainerRadius.radius10),
                            labelText: "Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureTextRef = !_obscureTextRef;
                                });
                              },
                              icon: Icon(
                                _obscureTextRef
                                    ? AppIcon.visibleOff
                                    : AppIcon.visibleOn,
                                color: _obscureTextRef
                                    ? Colors.grey
                                    : AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 10),
                          width: AppSize.width(context),
                          child: Text(
                            passwordWarning,
                            style: TextStyle(
                                color: passwordWarning == passwordMatch
                                    ? AppColors.correctColor
                                    : AppColors.errorColor,
                                fontSize: AppFontSize.small),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: passwordWarning == passwordMatch
                          ? AppColors.buttonColor
                          : AppColors.shimmerColor,
                    ),
                    onPressed: () async {
                      if (passwordController.text ==
                          passwordRefController.text) {
                        email = await ResetPasswordService.resetPassword(
                            widget.email,
                            passwordController.text,
                            widget.otp,
                            context);
                        print(email);
                      }
                      if (email != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()));
                      }
                    },
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.submit,
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
