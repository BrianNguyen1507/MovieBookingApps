import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/services/Users/signup/handleSignup.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, required this.email, required this.method});
  final dynamic email;
  final dynamic method;
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();

  ValidInput valid = ValidInput();
  final HandleSignupState _otpSend = HandleSignupState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OTP Verification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
                      String message = 'Please enter a 6-digit OTP';
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
