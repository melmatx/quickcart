// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/models/user_model/user_model.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context,rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context,rootNavigator: true).pop();
      showMessage(getMessageFromErrorCode(error.code.toString()), isTop: false);
      return false;
    }
  }

  Future<bool> signUp(
      String name, String email, String password, String phone, String address, BuildContext context) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
          id: userCredential.user!.uid, name: name, email: email, phone: phone, address: address, image: null);

      _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      Navigator.of(context,rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context,rootNavigator: true).pop();
      showMessage(getMessageFromErrorCode(error.code.toString()), isTop: false);
      return false;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  Future<bool> changePassword(
      String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      _auth.currentUser!.updatePassword(password);
      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // UserModel userModel = UserModel(
      //     id: userCredential.user!.uid, name: name, email: email, image: null);

      // _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      Navigator.of(context,rootNavigator: true).pop();
      showMessage("Password Changed");
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context,rootNavigator: true).pop();
      showMessage(error.code.toString());
      return false;
    }
  }

  Future<bool> changeEmail(
      String email, BuildContext context) async {
    try {
      showLoaderDialog(context);
      _auth.currentUser!.updateEmail(email);
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      showMessage(error.code.toString());
      return false;
    }
  }
}
