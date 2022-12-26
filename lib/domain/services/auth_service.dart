import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/* 
  Clase para realizar la autenticación y registro a través 
  de Firebase Auth y Firebase Storage
 */

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;

  Future<void> logIn(String email, password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message!, Colors.red);
    }
  }

  Future<void> signIn(String email, password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await createUserFavorites();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message!, Colors.red);
    }
  }

  Future<void> createUserFavorites() async {
    try {
      await _firebaseStorage.collection('favorite').doc(_firebaseAuth.currentUser!.uid).set({'favorites': []});
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message!, Colors.red);
    }
  }
}
