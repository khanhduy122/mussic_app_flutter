
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthRepo {

   static FirebaseStorage storage = FirebaseStorage.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;


  static Future<bool> userExists(String numberPhone) async {
    return (await firestore.collection("user_profile").doc(numberPhone).get()).exists;
  }
}