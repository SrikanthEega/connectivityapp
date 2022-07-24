import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseEvents {
  static Future<User?> registerUsingEmailPasswordEvent({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }
  static Future<User?> signInUsingEmailPasswordEvent({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }
  logOutEvent(){
    FirebaseAuth.instance.signOut();
  }
  getPreviousSearchPostCodes(String name, String date, String hobbies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? localData = [];
    if(name.isNotEmpty == true){
      localData[0] = name;
    }
    if(date.isNotEmpty == true){
      localData[1] = name;
    }
    if(hobbies.isNotEmpty == true){
      localData[2] = name;
    }
    prefs.setStringList('localData', localData);

  }
}
