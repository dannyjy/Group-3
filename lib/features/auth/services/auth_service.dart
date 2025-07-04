import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for the current user
  User? get currentUser => _auth.currentUser;

  Future<String> signUpUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && fullName.isNotEmpty) {
        // Register user with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Store additional user data in Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'password': password,
          'uid': cred.user!.uid,
        });

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message ?? 'An unknown error occurred.';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message ?? 'An unknown error occurred.';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
