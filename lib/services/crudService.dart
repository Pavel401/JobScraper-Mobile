import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobhunt_mobile/model/userModel.dart';

class CrudProvider {
  static final usersCollection = FirebaseFirestore.instance.collection("users");
  static Future<void> addUserToDB(UserModel user) async {
    await usersCollection.doc(user.id).set(user.toJson());
  }

  static Future<UserModel?> getUserFromDB(String uid) async {
    final DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
