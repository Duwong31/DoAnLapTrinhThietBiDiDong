
import '../models/auth/create_user_req.dart';
import '../models/auth/login_user_req.dart';
import 'package:dartz/dartz.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> login(LoginUserReq loginUserReq);
  Future<UserCredential?> loginWithGoogle(); 
}

class AuthFirebaseServiceImpl extends AuthFirebaseService{
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<Either> login(LoginUserReq loginUserReq) async{
    try{
      await _auth.signInWithEmailAndPassword(
        email: loginUserReq.email,
        password: loginUserReq.password, 
      );

      return const Right('Login was Successful!');
    } on FirebaseAuthException catch(e){
      String message = '';

      if(e.code == 'user-not-found'){
        message = 'No user found for that email.';
      } else if(e.code == 'wrong-password'){
        message = 'Wrong password provided for that user.';
      } else if(e.code == 'invalid-email'){
        message = 'The email address is badly formatted.';
      } else {
        message = e.message.toString();
      }
      return Left(message);
    }
  }
  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try{
      
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password, 
      );

      return const Right('Signup was Successful!');
    } on FirebaseAuthException catch(e){
      String message = '';

      if(e.code == 'weak-password'){
        message = 'The password provided is too weak.';
      } else if(e.code == 'email-already-in-use'){
        message = 'The account already exists for that email.';
      } else if(e.code == 'invalid-email'){
        message = 'The email address is badly formatted.';
      } else {
        message = e.message.toString();
      }
      return Left(message);
  }
}
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