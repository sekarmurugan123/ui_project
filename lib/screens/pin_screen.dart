import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ui_project/screens/welcome_screen.dart';
import 'package:ui_project/services/secure_storage_service.dart';
import 'package:ui_project/screens/pin_screen.dart';
class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final SecureStorageService storage=SecureStorageService();
  final TextEditingController pincontroller=TextEditingController();
  final TextEditingController confirmController=TextEditingController();
  void savePin()async{
    String pin=pincontroller.text.trim();
    if(pin.length!=6){
      showMessage("PIN do not match");
      return;
    }
     final pincode = storage.storeUserId(pin: pin);
    if(pincode!=null){
      showMessage('PIn created Successfully');
      await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomeScreen()));
    }
  }
  void showMessage(String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text),)
    );
  }
List<String> images=[
  "assets/images/img4.jpg",
  "assets/images/img5.jpeg",
  "assets/images/pic2.jpeg",
  "assets/images/pic2.jpg"
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.tealAccent.shade700,
          title: Center(child: const Text("Enter PIN",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40,),
          CarouselSlider(items: images.map((item)=>Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(image: AssetImage(item),fit: BoxFit.fill)
            ),
          )).toList() , options: CarouselOptions(
            height: 350,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeCenterPage: true,
            aspectRatio: 16/9,
            viewportFraction: 0.8,
          )),
          Spacer(),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: PinCodeTextField(appContext: context, length: 6,
                  controller: pincontroller,
                cursorHeight:19,
                  enableActiveFill: true,
                  textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldWidth: 50,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.lightBlue,
                      activeFillColor: Colors.yellow,
                      selectedFillColor: Colors.blue,
                      inactiveFillColor: Colors.grey.shade100,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(8)
                  ),
              ),
          ),
      SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
              savePin();
              },
            child: Text("Enter",style: TextStyle(color: Colors.black),),),
    Spacer(flex:2,)
        ],
      ),
    );
  }
}
// children: [
// Center(
// child: TextField(
// controller: pincontroller,
// keyboardType: TextInputType.number,
// obscureText: true,
// maxLength: 4,
// decoration: const InputDecoration(
// labelText: "Enter PIN",
// counterText: "",
// ),
// ),
// ),
// const SizedBox(height: 20),
// TextField(
// controller: confirmController,
// keyboardType: TextInputType.number,
// obscureText: true,
// maxLength: 4,
// decoration: const InputDecoration(
// labelText: "Confirm PIN",
// counterText: "",
// ),
// ),
// const SizedBox(height: 40),
// ElevatedButton(
// onPressed: savePin,
// child: const Text("Save PIN"),
// )
// ],
