import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ui_project/buttons/buttonpage.dart';
import 'package:ui_project/repository/auth_repo.dart';
import 'package:ui_project/repository/user_repo.dart';
import 'package:ui_project/screens/homescreen.dart';
import 'package:ui_project/screens/loginpage.dart';
import 'package:ui_project/screens/registerpage.dart';
import 'package:ui_project/services/biometric_service.dart';
import 'package:ui_project/services/local_storage_service.dart';
import 'package:ui_project/services/secure_storage_service.dart';
import 'package:ui_project/services/user_service.dart';
class WelcomeScreen extends StatefulWidget {

   WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  final SecureStorageService _secureStorageService=SecureStorageService();
   final UserService userService=UserService();
   TextEditingController pincontroller=TextEditingController();
   late AnimationController controller;
   late Animation<Offset> animation;
   final LocalStorageService _localStorageService=LocalStorageService();
  final BioMetricService _bioMetricService=BioMetricService();
  final style1=GoogleFonts.arima(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black);
  final style2=GoogleFonts.arima(fontSize: 15,color: Colors.black);
  @override

  void initState(){
    super.initState();
    controller=AnimationController(vsync: this,duration: Duration(seconds: 2));
    animation=Tween<Offset>(begin:Offset.zero,end:  Offset(2,0)).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn)
    );
    WidgetsBinding.instance.addPostFrameCallback((_)async=>_localStorageService.getUserId().then(
            (id)=>Future.delayed(Duration(seconds: 2),()async{
              if(id!=null){
                print("id:$id");
                final userdata= await userService.getUserData(id);
                if(userdata!=null && userdata.isBiometricEnabled){
                  print("userdata:$userdata");
                  await _bioMetricService.authenticateuser();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homescreen(userData:userdata)));
                }
              }

            }),
    ),
    );
  }
  Widget content(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: PinCodeTextField(appContext: context, length: 6),
        )
      ],
    );
  }

bool isVisible=false;
void navigateToRegister(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Registerpage()));
}
void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
}
bool isRound=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                  Container(
                    height: 350,
                     width: 350,
             decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(500),
                    boxShadow: [BoxShadow(
              color: Colors.black.withValues(alpha: 1),
              spreadRadius: 2,
              blurRadius: 3
                    )]
                ),
                child: ClipRRect(
            borderRadius: BorderRadius.circular(250),
                  child: Image.asset("assets/images/welcome_image.jpg",fit: BoxFit.fill,height: 300,),

                ),
              ),
              Spacer(flex: 1,),
              Text("Transform Speech into",style: style1,),
              Text("Text Effortlessly",style: style1,),
              SizedBox(height: 2,),
              Text("Capture every detail with RecogNotes.",style: style2,),
              Text("Record conservations.lectures.meetings. and",style: style2,),
              Text("more. and watch as they are trancscribed into",style: style2,),
              Text("accurrate text instantly.",style: style2,),

              Spacer(flex: 1,) ,
               Stack(
                 alignment: Alignment.center,
                 children: [
                   AnimatedOpacity(
                     opacity: isVisible?1:0,
                     duration: Duration(seconds: 2),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Button(height: 60, width: 150, text:"Register", backgroundColor:Colors.indigoAccent, textStyle:TextStyle(fontSize: 15,color: Colors.white,),borderColor: Colors.white,onpressed: (){
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Registerpage()));

                         },),

                         Button(height: 60, width: 150, text: "Sign In", backgroundColor: Colors.white,borderColor: Colors.indigoAccent, textStyle: TextStyle(fontSize:15,color: Colors.indigoAccent,),onpressed: (){
                           navigateToLogin();
                         },)
                       ],
                     ),
                   ),
                   AnimatedBuilder(
                     animation: animation,
                     builder: (context,_){
                       return SlideTransition(position: animation,
                         child: GestureDetector(
                           onTap: (){
                             if(controller.isCompleted){
                               setState(() {
                                 isVisible=false;
                               });
                               controller.reverse().then((_)=>controller.reset());
                             }else{
                               setState(() {
                                 isVisible=true;
                               });
                               controller.forward();
                             }
                           },
                           child: Container(
                             height: 100,
                             width: 100,
                             decoration: BoxDecoration(
                                 color: Colors.yellow,
                                 borderRadius: BorderRadius.circular(50)
                             ),
                             child: Icon(Icons.arrow_forward_ios),
                           ),
                         ),

                       );
                     },
                   )

                 ],

               ),


            ],

            ),
          )
      ),
    );
  }
}


