import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ui_project/models/user_model.dart';
class UserService{
  final _instance=FirebaseFirestore.instance;
  CollectionReference<Map<String,dynamic>> get users=>_instance.collection("users");

  Future<void> addOrUpdate(String uid,{bool isBiometricEnabled=false})async{
    DocumentReference docref= users.doc(uid);
    DocumentSnapshot snapshot=await docref.get();
    if(snapshot.exists){
     await docref.update({
        "isBiometricEnabled": isBiometricEnabled
      });
    }else{
      users.doc(uid).set({
        "id":uid,
        "isBiometricEnabled":isBiometricEnabled
      }
      );
    }
    }
  Future<UserModel?> getUserData(String uid)async{
    final documentSnapshot = await users.doc(uid).get();
    return UserModel(uid: documentSnapshot.data()!['id'], isBiometricEnabled: documentSnapshot.data()!['isBiometricEnabled']);
  }
}


