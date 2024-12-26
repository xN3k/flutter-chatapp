// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //sign in method
//   Future<UserCredential> signInWithEmailAndPassword(
//       String email, password) async {
//     try {
//       final UserCredential userCredentials = await _auth
//           .signInWithEmailAndPassword(email: email, password: password);
//       return userCredentials;
//     } on FirebaseAuthException catch (error) {
//       throw (error);
//     }
//   }

//   // sign up

//   Future<UserCredential>

//   // sign out
//   Future<void> signOut() async {
//     return await _auth.signOut();
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    });

    return userCredential;
  }

  Future<UserCredential> signup(
      String email, String password, String username, File image) async {
    try {
      final userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final storageRef = _storage
          .ref()
          .child('user_images')
          .child('${userCredential.user!.uid}.jpg');

      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username,
        'email': email,
        'image': imageUrl,
      });
      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
