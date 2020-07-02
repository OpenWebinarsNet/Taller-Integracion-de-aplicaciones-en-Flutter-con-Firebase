import 'package:firebase_auth/firebase_auth.dart';

class UserController {

  Future<FirebaseUser> getUserAuthenticated() {
    return FirebaseAuth.instance.currentUser();
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<String> getUserUID() async {
    final user = await getUserAuthenticated();
    return user.uid ?? null;
  }
}
