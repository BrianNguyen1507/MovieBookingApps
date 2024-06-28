import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/pages/sign-in-up/components/term-conditions.dart';
import 'package:movie_booking_app/pages/sign-in-up/forgotPassword.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/signIn/handleSignin.dart';
import 'package:movie_booking_app/services/Users/signup/handleSignup.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final HandleSignupState _signupState = HandleSignupState();
  final HandleSigninState _signinState = HandleSigninState();
  final ValidInput _valid = ValidInput();
  final Preferences _pref = Preferences();
  bool _obscureText = true;
  bool _isSignUp = false;
  bool _isChecked = false;

  void init() {
    super.initState();
    _pref.clear();
    Provider.of<UserProvider>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IndexPage(initialIndex: 2),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 2, top: 25),
                      child: Text(
                        _isSignUp
                            ? AppLocalizations.of(context)!.sup
                            : AppLocalizations.of(context)!.sin,
                        style: const TextStyle(
                          fontSize: AppFontSize.big,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    _isSignUp
                        ? Column(
                            children: [
                              _buildTextField(
                                  AppLocalizations.of(context)!.email,
                                  _emailController),
                              _buildPasswordField(
                                  AppLocalizations.of(context)!.password,
                                  _passwordController),
                              _buildPasswordField(
                                  AppLocalizations.of(context)!.repassword,
                                  _confirmPasswordController),
                              _buildTextField(
                                  AppLocalizations.of(context)!.fullname,
                                  _nameController),
                              _buildTextField(
                                  AppLocalizations.of(context)!.phone,
                                  _phoneNumberController),
                              _buildGenderField(),
                              _buildDateOfBirthField(),
                              _buildCheckBox(context),
                              _buildButton(
                                  _isSignUp
                                      ? AppLocalizations.of(context)!.submit
                                      : AppLocalizations.of(context)!.send,
                                  () async {
                                _emailController.text;
                                _passwordController.text;
                                _nameController.text;
                                _phoneNumberController.text;
                                _selectedGender;
                                _dobController.text;
                                _onSignUpPressed();
                              }, true),
                              Center(
                                heightFactor: 3,
                                child: Text(
                                  AppLocalizations.of(context)!.ahac,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: AppFontSize.small,
                                  ),
                                ),
                              ),
                              _buildSwitchButton(),
                            ],
                          )
                        : Column(
                            children: [
                              _buildTextField(
                                  AppLocalizations.of(context)!.email,
                                  _emailController),
                              _buildPasswordField(
                                  AppLocalizations.of(context)!.password,
                                  _passwordController),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassWord()));
                                  },
                                  child: const Text(
                                    'Forgot password',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                              ),
                              _buildButton(AppLocalizations.of(context)!.send,
                                  () {
                                _emailController.text;
                                _passwordController.text;
                                _onSignInPressed();
                              }, false),
                              Center(
                                heightFactor: 3,
                                child: Text(
                                  AppLocalizations.of(context)!.dhac,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: AppFontSize.small,
                                  ),
                                ),
                              ),
                              _buildSwitchButton(),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter all fields';
              }
              return null;
            },
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 3.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: labelText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String labelText, TextEditingController controller) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            obscureText: _obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 3.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: labelText,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? AppIcon.visibleOff : AppIcon.visibleOn,
                  color: _obscureText ? Colors.grey : AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int? _selectedGender;
  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DropdownButtonFormField<int>(
        value: _selectedGender,
        onChanged: (value) {
          setState(() {
            _selectedGender = value!;
            _valid.isValidGender(_selectedGender.toString());
          });
        },
        items: [
          DropdownMenuItem<int>(
            value: 0,
            child: Text(AppLocalizations.of(context)!.male),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text(AppLocalizations.of(context)!.female),
          ),
        ],
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.gender,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  DateTime? _selectedDate;
  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.dob,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text =
            ConverterUnit.convertToDate(_selectedDate.toString());
      });
    }
  }

  Widget _buildButton(
    String text,
    VoidCallback onPressed,
    bool isSignUp,
  ) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: 350.0,
        height: 50.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              !isSignUp || _isChecked
                  ? AppColors.buttonColor
                  : AppColors.commonColor,
            ),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          onPressed: isSignUp ? (_isChecked ? onPressed : null) : onPressed,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppFontSize.small,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckBox(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: 'Please accept Condition',
          child: Checkbox(
            value: _isChecked,
            activeColor: AppColors.primaryColor,
            checkColor: AppColors.containerColor,
            side: const BorderSide(
              color: AppColors.backgroundColor,
            ),
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  _isChecked = value;
                });
              }
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            showTermsAndConditionsBottomSheet(context);
          },
          child: RichText(
            text: const TextSpan(
              text: 'I ACCEPT ',
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'TERM AND CONDITIONS',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: 350.0,
        height: 50.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.commonColor),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          onPressed: () {
            _onswitch();
          },
          child: Text(
            _isSignUp
                ? AppLocalizations.of(context)!.sin
                : AppLocalizations.of(context)!.sup,
            style: const TextStyle(
              color: AppColors.darktextColor,
              fontSize: AppFontSize.small,
            ),
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed() async {
    if (_valid.checkRepassword(
        _passwordController.text, _confirmPasswordController.text, context)) {
      await _signupState.validSignUp(
        context,
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _valid.isValidGender(
          _selectedGender.toString(),
        ),
        _phoneNumberController.text,
        _dobController.text,
      );
    } else {
      _valid.showMessage(
          context, 'Passwords do not match', AppColors.errorColor);
    }
  }

  void _onSignInPressed() async {
    await _signinState.validSignIn(
      context,
      _emailController.text,
      _passwordController.text,
    );
  }

  void _onswitch() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }
}
