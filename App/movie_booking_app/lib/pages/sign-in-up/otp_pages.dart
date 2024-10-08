import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/services/Users/signup/handle_sign_up.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, required this.email, required this.method});
  final dynamic email;
  final dynamic method;
  @override
  OTPPageState createState() => OTPPageState();
}

class OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();

  ValidInput valid = ValidInput();
  final HandleSignupState _otpSend = HandleSignupState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Common.customAppbar(context, null, AppStyle.headline2,
          'OTP Verification', AppColors.appbarColor, AppColors.containerColor),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'An otp has been sent to the email ',
                      style: TextStyle(
                          fontSize: AppFontSize.medium,
                          color: AppColors.darktextColor),
                    ),
                    Text(
                      widget.email,
                      style: const TextStyle(
                          fontSize: AppFontSize.medium,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Text(
                  'Please enter the 6-digit OTP',
                  style: TextStyle(
                      fontSize: AppFontSize.medium,
                      color: AppColors.darktextColor),
                ),
                const SizedBox(height: 20.0),
                _buildOTPTextField(),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.buttonColor),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: ContainerRadius.radius10),
                    ),
                  ),
                  onPressed: () async {
                    String otp = _otpController.text.toString();
                    if (otp.length != 6) {
                      String message = AppLocalizations.of(context)!.otp_digit;
                      valid.showMessage(context, message, AppColors.errorColor);
                    }
                    _otpSend.validOTP(
                        context, widget.email, otp, widget.method);
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSize.small,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPTextField() {
    return TextField(
      controller: _otpController,
      maxLength: 6,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        hintText: 'Enter OTP',
        counterText: '',
        border: OutlineInputBorder(),
      ),
    );
  }
}
