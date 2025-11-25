class UserModel{
  final String uid;
  final bool isBiometricEnabled;

  UserModel({
    required this.uid,
    required this.isBiometricEnabled
});
  UserModel copyWith(){
    return UserModel(uid: uid,
        isBiometricEnabled: isBiometricEnabled);
  }
  @override
  String toString(){
    return "UserModel uid:$uid,isBiometricEnabled:$isBiometricEnabled";
  }

}
