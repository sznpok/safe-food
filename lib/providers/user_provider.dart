import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '/models/user.dart';

class UserProvider extends ChangeNotifier {
  late UserModel _user;

  setUser(Map obj) {
    _user = UserModel.fromJson(obj);
    notifyListeners();
  }

  UserModel get user => _user;

  String get userId => _user.uuid;

  Map<String, dynamic> createUser({
    required String uuid,
    required String email,
    required String name,
    required String address,
    required String phoneNumber,
    String? panNumber,
    required bool isFoodDonor,
  }) {
    _user = UserModel(
      uuid: uuid,
      email: email,
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      isFoodDonor: isFoodDonor,
      panNumber: panNumber,
      image: null,
      photoUrl: null,
    );
    final map = _user.toJson();
    // _user = null;
    return map;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to send password reset email: ${e.message}');
    }
  }

  Map<String, dynamic> updateUser({
    required String name,
    required String address,
    required String phoneNumber,
    String? panNumber,
    required bool isFoodDonor,
  }) {
    _user = UserModel(
      uuid: _user.uuid,
      email: _user.email,
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      isFoodDonor: isFoodDonor,
      panNumber: panNumber,
      image: _user.tempImage,
      photoUrl: null,
    );

    notifyListeners();
    return _user.toJson();
  }

  updateUserImage(String image) {
    _user.tempImage = image;
    notifyListeners();
  }

  Stream<List<UserModel>> getAllUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  void logout() {
    // Reset the user
    notifyListeners();
  }
}
