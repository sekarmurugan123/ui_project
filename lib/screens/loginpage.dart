import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_project/buttons/buttonpage.dart';
import 'package:ui_project/buttons/socialbutton.dart';
import 'package:ui_project/models/user_model.dart';
import 'package:ui_project/repository/auth_repo.dart';
import 'package:ui_project/screens/homescreen.dart';
import 'package:ui_project/screens/registerpage.dart';
import 'package:ui_project/services/auth_service.dart';
import 'package:ui_project/services/biometric_service.dart';
import 'package:ui_project/services/local_storage_service.dart';
import 'package:ui_project/services/secure_storage_service.dart';
import 'package:ui_project/services/user_service.dart';
import 'package:ui_project/utils.dart';
class LoginPage extends StatefulWidget {

  final String? email;
  final String? password;

  const LoginPage({super.key, this.email, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String> images=[
    "assets/images/img11.jpg",
    "assets/images/apple.png",
    "assets/images/facebook.png"
  ];
  FocusNode focusNode=FocusNode();
  bool obsecured=true;
  final UserService _userService=UserService();
  final SecureStorageService _secureStorageService=SecureStorageService();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final AuthRepo _authRepo=AuthRepo();
  final LocalStorageService _localStorageService=LocalStorageService();
  final UserService  userService=UserService();
  late GlobalKey<FormState> formKey;

  @override
  void initState(){
    super.initState();
    emailController=TextEditingController(text: widget.email);
    passwordController=TextEditingController(text: widget.password);
    formKey=GlobalKey<FormState>();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
@ override

  String? validate(String? str,{String fieldType='email'}){
    if(str==null || str.isEmpty){
      return "$fieldType is required";
    }
    if(fieldType=="email"){
      if(!str.contains("@")){
        return "Invalid $fieldType";
      }
    }
    if(fieldType=="password"){
      if(str.length<6){
        return "$fieldType must be more than 6 letters ";
      }
    }
    return null;
  }
//
void navigateToRegister()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Registerpage()));


void login(BuildContext context)async{
    if(formKey.currentState!.validate()){
      final userdata=await _authRepo.loginIn(emailController.text, passwordController.text);
      if(userdata!=null){
        print("got Data");
        biometricEnable(userdata.uid, context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homescreen(userData:userdata)));

      }
    }
}

void biometricEnable(String uid, BuildContext context){
 showDialog(context: context, builder: (context){
   return Dialog(
     backgroundColor: Colors.green,
     child: Padding(padding: EdgeInsets.all(8),
       child: Column(
       mainAxisSize: MainAxisSize.min,
         children: [
           Text("Enable Biometric"),
           SizedBox(
             height: 10,
           ),
           Row(

             children: [
               ElevatedButton(onPressed: (){
                 print("id: $uid");
                 _userService.addOrUpdate(uid,isBiometricEnabled: true,);
                 _localStorageService.storeUserId(uid);
                 }, child: Text("Enable"),),
               SizedBox(width: 7,),
               ElevatedButton(onPressed: (){}, child: Text("Disable"))
             ],
           )
         ],
       ),
     ),
   );
 });
 // Navigator.pop(context);
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body:
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 1,),
                Text("Create an account",style:GoogleFonts.aclonica(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",style: GoogleFonts.akshar(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w200)),
                    TextButton(onPressed:(){
                      navigateToRegister();
                    },
                        child: Text("Sign in",style: GoogleFonts.abel(color: Colors.indigoAccent,fontSize: 15),)),
                  ],
                ),
                Spacer(),
                TextFormField(
                  autofocus: true,
                  controller: emailController,
                  validator:(value)=>validate(value,fieldType: 'email'),
                  decoration: InputDecoration(
                      hintText: "Email"
                  ),
                  onFieldSubmitted: (value){
                    if(value.isNotEmpty){
                      focusNode.requestFocus();
                    }
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  focusNode: focusNode,
                  validator: (str)=>validate(str,fieldType: 'password'),
                 obscureText: obsecured,
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon:IconButton(onPressed: (){
                        if(obsecured){
                          setState(() {
                            obsecured=false;
                            Future.delayed(Duration(seconds:3),()=>setState(() {
                              obsecured=true;
                            }));
                          });
                        }
                      }, icon: obsecured?
                             Icon(Icons.visibility_off_outlined):
                     Icon(Icons.visibility))
                  ),
                ),
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Recovery Password",style:GoogleFonts.acme(fontSize: 15,color: Colors.black54),),
                  ],
                ),
                SizedBox(height: 15,),
                Button(height: 60, width: 400, text: "Sign In", backgroundColor: Colors.indigoAccent, textStyle:TextStyle(color: Colors.white),borderColor: Colors.cyanAccent,onpressed: (){
                  login(context);
                },),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 10,
                      ),
                    ),
                    Text("or SignUp with",style: GoogleFonts.allura(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black54),),
                    Expanded(
                      child: Divider(
                        endIndent: 10,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  images.map((imagePath)=>Socialbutton(imagePath: imagePath)).toList()
                ),

                Spacer()
              ],
            ),
          ),
        ),
      ),
    );

  }
}



