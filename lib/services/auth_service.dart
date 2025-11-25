import 'package:firebase_auth/firebase_auth.dart';
import 'package:ui_project/models/user_model.dart';

class AuthService{
  final _auth=FirebaseAuth.instance;
  Future<void> createUser(String email,String password)async{
  await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<UserCredential?> loginIn(String email,String password)async{
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      print("error:$e");
    }

  }

}