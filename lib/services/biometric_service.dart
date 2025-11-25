import 'package:local_auth/local_auth.dart';

class BioMetricService{
 final LocalAuthentication _auth=LocalAuthentication();
 Future<bool> isBiometricAvailable()async{
   final ifCheck= await _auth.canCheckBiometrics;
   final isDeviceSupport=await _auth.isDeviceSupported();
   return ifCheck && isDeviceSupport;

 }
 Future<bool> authenticateuser()async{
   if(await isBiometricAvailable()){
     return _auth.authenticate(
       options: const AuthenticationOptions(
         biometricOnly: true,
         stickyAuth: true
       ),
         localizedReason: "please authenticate to user");
   }
   return false;
 }
}