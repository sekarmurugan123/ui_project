import 'package:shared_preferences/shared_preferences.dart';
class LocalStorageService{
  static const _userIdkey='userId';
  Future<void> storeUserId(String uid)async{
    final SharedPreferences pref= await SharedPreferences.getInstance();
    await pref.setString(_userIdkey, uid);
  }
  Future<String?> getUserId()async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(_userIdkey);
  }

}