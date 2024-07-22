import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/appdata.dart';
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/infomation/changePassword.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordState();
  }
}

class ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true;
  bool _obscureNewText = true;
  bool _obscureTextRef = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController passwordRefController = TextEditingController();
  ValidInput valid = ValidInput();
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
            Center(
              child: Text(
                AppLocalizations.of(context)!.change_pass,
                style: const TextStyle(
                    fontSize: AppFontSize.large,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: AppColors.darktextColor),
                      obscureText: _obscureNewText,
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
                          borderRadius: ContainerRadius.radius10,
                        ),
                        labelText: AppLocalizations.of(context)!.password,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureNewText = !_obscureNewText;
                            });
                          },
                          icon: Icon(
                            _obscureNewText
                                ? AppIcon.visibleOff
                                : AppIcon.visibleOn,
                            color: _obscureNewText
                                ? Colors.grey
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                      controller: newPasswordController,
                      style: const TextStyle(color: AppColors.darktextColor),
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
                          borderRadius: ContainerRadius.radius10,
                        ),
                        labelText: AppLocalizations.of(context)!.new_pass,
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
                                passwordWarning = newPasswordController.text !=
                                        passwordRefController.text
                                    ? "Password do not match!"
                                    : passwordMatch;
                              }
                            });
                          },
                          style:
                              const TextStyle(color: AppColors.darktextColor),
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
                              borderRadius: ContainerRadius.radius10,
                            ),
                            labelText: AppLocalizations.of(context)!.re_pass,
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
                      if (passwordWarning == passwordMatch) {
                        Account account =
                            await ChangePasswordService.changePassword(
                                passwordController.text,
                                newPasswordController.text,
                                context);
                        Preferences pre = Preferences();
                        String? email = await pre.getEmail();
                        if (account.email == email) {
                          valid.showMessage(
                              context,
                              "Change password successfully",
                              AppColors.correctColor);
                          valid.showAlertCustom(
                            context,
                            "Login version has expired",
                            "OK",
                            false,
                            () => _onPressLogout(context),
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(AppLocalizations.of(context)!.tieptuc,
                              style: AppStyle.buttonText2),
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

  void _onPressLogout(BuildContext context) {
    Preferences pref = Preferences();
    Provider.of<UserProvider>(context, listen: false).logout(context);
    pref.removeSinginInfo();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
