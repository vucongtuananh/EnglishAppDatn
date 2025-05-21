// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/user_model.dart';

class AuthRepository {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserFromFirestore(String uid) async {
    try {
      // DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
      // if (doc.exists) {
      //   return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      // }
      return null;
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      // await _firestore.collection('Users').doc(user.uid).update(user.toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}