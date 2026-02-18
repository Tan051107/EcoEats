import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential>signIn({
    required String email,
    required String password,
  })async{
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential>signUp({
    required String email,
    required String password,
  })async{
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential>signInWithGoogle()async{
    try{
      final GoogleSignInAccount googleAcc = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleAcc.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken
      );

      return await _auth.signInWithCredential(credential);
    }
    catch(err){
      throw Exception("Failed to log in with google , $err");
    }
  }

  Future<void>signOut()async{
    await _auth.signOut();
  }
}