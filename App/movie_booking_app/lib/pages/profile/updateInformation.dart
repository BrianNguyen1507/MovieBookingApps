import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/services/Users/infomation/getMyInfoService.dart';
import 'package:movie_booking_app/services/Users/infomation/updateAccount.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({super.key});

  @override
  UpdateInformationState createState() =>
      UpdateInformationState();
}

class UpdateInformationState extends State<UpdateInformation> {
  final TextEditingController fullNameCtl = TextEditingController();
  final TextEditingController phoneCrl = TextEditingController();
  final TextEditingController dobCtl = TextEditingController();
  String? selectedGender;
  late Account account;
  String base64Avatar="";
  String email="";
  String avatar="";
  bool _isLoading = true;
  ImagePicker picker = ImagePicker();
  late File image;
  ValidInput valid = ValidInput();

  void _onGenderChanged(String? value) {
    setState(() {
      selectedGender = value;
    });
  }
  @override
  void initState() {
    super.initState();
    _fetchMyInformation();
  }
  Future<void> _fetchMyInformation() async {
    try {
      Account account = await MyInformation.getMyInformation();
      setState(() {
        account = account;
        phoneCrl.text = account.phoneNumber;
        fullNameCtl.text = account.fullName;
        _selectedDate = DateTime.parse(account.dayOfBirth) ;
        email=account.email;
        dobCtl.text = account.dayOfBirth;
        selectedGender = account.gender=="Nam"?"Male":"Female";
        avatar= account.avatar;
        if(account.avatar!=""){
          base64Avatar=account.avatar;
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching information: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Information"),
        backgroundColor: Colors.blue,
        // Change to your AppColors.appbarColor
        titleTextStyle: const TextStyle(
          color: Colors.white, // Change to your AppColors.titleTextColor
          fontSize: 18.0, // Change to your AppFontSize.midMedium
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
        Container(
        margin: const EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: GestureDetector(
          onTap: () async  {
           final  pickedImage = await picker.pickImage(source: ImageSource.gallery);
            setState(() {
              if(pickedImage!=null){
                image = File(pickedImage.path);
                avatar="file";
                base64Avatar = base64Encode(image.readAsBytesSync());
              }
            });

          },
          child: imageAvatar(avatar)
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child:  Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align left
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                  ),
                ),
              ),
              Container(
                margin:  EdgeInsets.only(top: 10),
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: AppFontSize.lowMedium
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: fullNameCtl,
            decoration: const InputDecoration(
              labelText: "Full Name",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: phoneCrl,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // Align items to the start
            children: [
              Row(
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(fontSize: 16.0), // Adjust font size
                  ),
                  const SizedBox(width: 30),
                  Radio<String>(
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: _onGenderChanged,
                    activeColor: Colors.red,
                  ),
                  const Text('Male'),
                ],
              ),
              const SizedBox(width: 30),
              // Add some space between the radio buttons
              Row(
                children: [
                  Radio<String>(
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged: _onGenderChanged,
                    activeColor: Colors.red,
                  ),
                  const Text('Female'),
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: dobCtl,
            decoration: InputDecoration(
              labelText: "Day of birth",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
          ),
        ),
      ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: AppSize.width(context),
                child:  Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                    ),
                    onPressed: () async {

                      Account accountRequest = Account(
                          email: "",
                          avatar: base64Avatar,
                          fullName: fullNameCtl.text,
                          phoneNumber: phoneCrl.text,
                          gender: selectedGender=="Male"?"Nam":"Nữ",
                          dayOfBirth: ConverterUnit.convertToDate(dobCtl.text));
                      accountRequest = await UpdateAccount.updateAccount(accountRequest);
                      if(accountRequest.email==email){
                        valid.showMessage(context, "Update successfully", AppColors.correctColor);
                      }
                    },
                    child: const SizedBox(
                      width: 100,
                        child: Text(
                            "Update",
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              )
      ],
    ),)
    ,
    );
  }
  DateTime? _selectedDate;
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
        dobCtl.text =
            ConverterUnit.convertToDate(_selectedDate.toString());
      });
    }
  }
  Widget imageAvatar(String imgUnit8Bit){
    if(imgUnit8Bit==""){
      return Image.asset('assets/images/avatarDefault.png');
    }
    else if(imgUnit8Bit=="file"){
      return Image.file(image);
    }
    return Image.memory( ConverterUnit.base64ToUnit8(imgUnit8Bit));
  }
}
