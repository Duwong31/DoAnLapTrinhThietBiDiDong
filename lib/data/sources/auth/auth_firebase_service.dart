import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:soundflow/data/models/auth/create_user_req.dart';

abstract class AuthFirebaseService {
  Future<void> signup(CreateUserReq createUserReq);
  Future<void> login();
  Future<UserCredential?> loginWithGoogle(); 
}

class AuthFirebaseServiceImpl extends AuthFirebaseService{
  final _auth = FirebaseAuth.instance;

  @override
  Future<void> login(){
    throw UnimplementedError();
  }
  @override
  Future<void> signup(CreateUserReq createUserReq) async {
    try{
      
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        // phone: createUserReq.phone,
        password: createUserReq.password, 
      );

    } on FirebaseAuthException catch(e){
      throw e;
    }
  }
  @override
  Future<UserCredential?> loginWithGoogle() async{
    try{
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      return await _auth.signInWithCredential(cred);
    } catch(e){
      print(e.toString());
    }
    return null;
  }
}
