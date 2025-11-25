import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_project/buttons/buttonpage.dart';
import 'package:ui_project/buttons/socialbutton.dart';
import 'package:ui_project/repository/auth_repo.dart';
import 'package:ui_project/screens/loginpage.dart';
import 'package:ui_project/services/auth_service.dart';
import 'package:ui_project/services/biometric_service.dart';
import 'package:ui_project/services/secure_storage_service.dart';
class Registerpage extends StatefulWidget {
  const Registerpage({super.key });
  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  List<String> images=[
    "assets/images/img11.jpg",
    "assets/images/apple.png",
    "assets/images/facebook.png"
  ];
  bool obscured=true;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;
  final AuthRepo authRepo=AuthRepo();
  late FocusNode focusNode;

@ override
void initState(){
   super.initState();
   emailController=TextEditingController();
   passwordController=TextEditingController();
   formKey=GlobalKey<FormState>();
   focusNode=FocusNode();
}


  String? validate(String? str,{String fieldType="email"}){
    if(str==null || str.isEmpty){
      return "$fieldType is required";
    }
     if(fieldType=="email"){
       if(!str.contains("@")){
         return "@ must be initialize in $fieldType";
       }
     }
    if(fieldType=="password"){
      if(str.length<6){
        return "$fieldType must be more than 6 letters ";
      }
    }
    return null;
  }
toggleEye(){
   setState(() {
     obscured=!obscured;
   });
}
  void register()async{
    if(formKey.currentState!.validate()){
      await authRepo.createUser(emailController.text, passwordController.text);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage(email: emailController.text,password: passwordController.text,)));
    }
  }


  @override
  void navigaToLogin()async{
    if(formKey.currentState!.validate()){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
    }
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
                        navigaToLogin();
                      },child: Text("Login",style: GoogleFonts.abel(color: Colors.indigoAccent,fontSize: 15),)),
                      ],
              ),
                Spacer(),
                TextFormField(
                  autofocus: true,
                  controller: emailController,
                  validator:(str)=>validate(str,fieldType: "email"),
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
                    obscureText: obscured,
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                      suffixIcon: IconButton(onPressed: (){
                        if(obscured){
                          setState(() {
                            obscured=false;
                            Future.delayed(Duration(seconds:2),()=>setState(() {
                              obscured=true;
                            }));
                          });
                        }
                      },
                      icon:obscured
                        ? Icon(Icons.visibility_off_outlined)
                        : Icon(Icons.visibility_outlined)
                      )
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
                  Button(height: 60, width: 400, text: "continue", backgroundColor: Colors.indigoAccent, textStyle:TextStyle(color: Colors.white),borderColor: Colors.cyanAccent,onpressed: (){
                  register();
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
                    children:
                      images.map((imagePath)=>Socialbutton(imagePath: imagePath)).toList()

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
