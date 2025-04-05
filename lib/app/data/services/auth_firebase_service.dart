
import 'package:dartz/dartz.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthFirebaseService {
  Future<UserCredential?> loginWithGoogle(); 
}

class AuthFirebaseServiceImpl extends AuthFirebaseService{
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserCredential?> loginWithGoogle() async{
    try{
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      return await _auth.signInWithCredential(cred);
    } catch(e){
      print(e.toString());
    }
    return null;
  }
  
}