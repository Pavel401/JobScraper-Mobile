import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobhunt_mobile/model/userModel.dart';
import 'package:jobhunt_mobile/services/crudService.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// create user
  Future<UserModel?> signUpUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        UserModel user;
        user = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName ?? '',
            photoUrl: "",
            createdAt: Timestamp.now(),
            gender: '',
            dob: DateTime.now(),
            phoneNumber: "",
            address: "",
            city: "",
            state: "",
            country: "",
            pincode: "",
            about: "",
            resumeUrl: "",
            githubUrl: "",
            linkedinUrl: "",
            twitterUrl: "",
            websiteUrl: "",
            skills: [],
            tokens: []);
        CrudProvider.addUserToDB(user!);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<UserModel?> signInUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Retrieve user data from Firestore or any other source if needed
        // For now, returning a basic user object
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          photoUrl: "",
          createdAt: Timestamp.now(),
          gender: '', // Add the required argument for 'gender'
          dob: DateTime.now(),
          phoneNumber: "", // Add the required argument for 'phoneNumber'
          address: "", // Add the required argument for 'address'
          city: "", // Add the required argument for 'city'
          state: "", // Add the required argument for 'state'
          country: "", // Add the required argument for 'country'
          pincode: "", // Add the required argument for 'pincode'
          about: "", // Add the required argument for 'about'
          resumeUrl: "", // Add the required argument for 'resumeUrl'
          githubUrl: "", // Add the required argument for 'githubUrl'
          linkedinUrl: "", // Add the required argument for 'linkedinUrl'
          twitterUrl: "", // Add the required argument for 'twitterUrl'
          websiteUrl: "", // Add the required argument for 'websiteUrl'
          skills: [], // Add the required argument for 'skills'
          tokens: [], // Add the required argument for 'tokens'
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///signOutUser
  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
