import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  static const String _userKey='userKey';
  final FlutterSecureStorage _flutterSecureStorage=FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true
    )
  );
  AndroidOptions _androidOptions()=>AndroidOptions(
    encryptedSharedPreferences: true
  );
  Future<void> storeUserId({required String pin})async{
    await _flutterSecureStorage.write(key: _userKey, value: pin);
  }
  void deleteId()async{
   await _flutterSecureStorage.delete(key: _userKey,aOptions: _androidOptions());
  }
  Future<String?> getUserId()async{
    await _flutterSecureStorage.read(key: _userKey,aOptions: _androidOptions());
  }
}