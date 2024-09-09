import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '/widgets/general_alert_dialog.dart';

class FirebaseHelper {
  addOrUpdateContent(
    BuildContext context, {
    required String collectionId,
    required String whereId,
    required String whereValue,
    required Map<String, dynamic> map,
  }) async {
    try {
      GeneralAlertDialog().customLoadingDialog(context);
      final data = await getData(
        collectionId: collectionId,
        whereId: whereId,
        whereValue: whereValue,
      );
      if (data.docs.isEmpty) {
        await FirebaseFirestore.instance.collection(collectionId).add(map);
      } else {
        data.docs.first.reference.update(map);
      }
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      throw ex.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamWithWhere({
    required String collectionId,
    required String whereId,
    required Object? whereValue,
  }) async* {
    try {
      final fireStore = FirebaseFirestore.instance;

      yield* fireStore
          .collection(collectionId)
          .where(whereId, isEqualTo: whereValue)
          .snapshots();
    } catch (ex) {
      throw ex.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamWithMultipleWhere({
    required String collectionId,
    required String whereId,
    required Object? whereValue,
    required String whereIdSecond,
    required Object? whereValueSecond,
  }) async* {
    try {
      final fireStore = FirebaseFirestore.instance;

      yield* fireStore
          .collection(collectionId)
          .where(whereId, isEqualTo: whereValue)
          .where(whereIdSecond, isEqualTo: whereValueSecond)
          .snapshots();
    } catch (ex) {
      throw ex.toString();
    }
  }

// Method to send message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('chats').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (ex) {
      throw ex.toString();
    }
  }

  // Method to get chat messages between two users
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages({
    required String userId1,
    required String userId2,
  }) {
    try {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('senderId', isEqualTo: userId1)
          .where('receiverId', isEqualTo: userId2)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (ex) {
      throw ex.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream({
    required String collectionId,
  }) async* {
    try {
      final fireStore = FirebaseFirestore.instance;

      yield* fireStore.collection(collectionId).snapshots();
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData({
    required String collectionId,
    required String whereId,
    required String whereValue,
  }) async {
    try {
      final fireStore = FirebaseFirestore.instance;
      // fireStore.collection(collectionId).doc(docId).update(data)
      final data = await fireStore
          .collection(collectionId)
          .where(whereId, isEqualTo: whereValue)
          .get();
      return data;
    } catch (ex) {
      throw ex.toString();
    }
  }

  addData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(collectionId).add(map);
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> updateFoodData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
    required String documentId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionId)
          .doc(documentId)
          .update(map);

      print("Data updated successfully.");
    } catch (ex) {
      print("Error updating data: ${ex.toString()}");
    }
  }

  deleteFoodData(
    BuildContext context, {
    required String collectionId,
    required String documentId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionId)
          .doc(documentId)
          .delete();
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }

  updateData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
    required String docId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionId)
          .doc(docId)
          .update(map);
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }
}
