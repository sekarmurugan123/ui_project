import 'package:firebase_auth/firebase_auth.dart';
import 'package:ui_project/models/user_model.dart';
import 'package:ui_project/repository/user_repo.dart';
import 'package:ui_project/services/auth_service.dart';
import 'package:ui_project/services/user_service.dart';

class AuthRepo{
 final AuthService _authService=AuthService();


  Future<void> createUser(String email,String password)async{
    return await _authService.createUser(email, password);
  }
  Future<UserModel?> loginIn(String email,String password)async{
    final userData = await _authService.loginIn(email, password);
    if(userData!=null){
      print("userCredential: $userData");
      print("hello");
  final UserModel userModel=UserModel(uid: userData.user?.uid??"", isBiometricEnabled: false);
  return userModel;
      }
    return null;
    }

    }


