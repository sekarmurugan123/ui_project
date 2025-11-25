import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ui_project/repository/auth_repo.dart';
import 'package:ui_project/screens/pin_screen.dart';
import 'package:ui_project/screens/welcome_screen.dart';
import 'package:ui_project/firebase_options.dart';
import 'package:ui_project/services/auth_service.dart';
  void main()async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    runApp(MyApp());
  }


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState()=>_MyApp();
}
  class _MyApp extends State<MyApp>{
    TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD APP',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigoAccent,
       inputDecorationTheme: InputDecorationTheme(
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(20),
           borderSide: BorderSide(color: Colors.transparent),
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: BorderSide(color: Colors.transparent)
         ),
         errorBorder: OutlineInputBorder(
           borderSide: BorderSide(color: Colors.transparent),
           borderRadius: BorderRadius.circular(10)
         ),
         focusedErrorBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: BorderSide(color: Colors.transparent)
         ),
         fillColor: Colors.grey.shade200,
         filled: true
       ),
        scaffoldBackgroundColor: Colors.white,

      ),
      home: CreatePinScreen(),
    );

  }
    Widget content(){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: PinCodeTextField(appContext: context, length: 6,
                controller: controller,cursorHeight:19,
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
                onChanged: (value){
                print(value);
                }

              )
          )
        ],
      );
    }
}
