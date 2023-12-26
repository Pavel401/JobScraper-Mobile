import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobhunt_mobile/model/userModel.dart';

class CrudProvider {
  static final usersCollection = FirebaseFirestore.instance.collection("users");
  static Future<void> addUserToDB(RawModel user) async {
    if (user.isRecruiter == true) {
      await usersCollection.doc(user.recruiter!.id).set(user.toJson());
    } else {
      await usersCollection.doc(user.user!.id).set(user.toJson());
    }
  }

  static Future<RawModel?> getUserFromDB(String uid) async {
    final DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    if (userDoc.exists) {
      return RawModel.fromJson(userDoc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<void> updateUserInDB(RawModel updatedUser) async {
    await usersCollection
        .doc(updatedUser.user!.id)
        .update(updatedUser.toJson());
  }
}
