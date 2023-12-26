import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobhunt_mobile/model/userModel.dart';
import 'package:jobhunt_mobile/services/crudService.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// create user
  Future<RawModel?> signUpUser(
    String email,
    String password,
    bool isRecruiter,
  ) async {
    if (isRecruiter) {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      RecruiterModel recruiter;
      if (firebaseUser != null) {
        recruiter = RecruiterModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          companyName: '',
          companyLogoUrl: '',
          createdAt: Timestamp.now(),
          industry: '',
          phoneNumber: '',
          address: '',
          city: '',
          state: '',
          country: '',
          pincode: '',
          about: '',
          websiteUrl: '',
          jobPostings: [],
          tokens: [],
        );

        RawModel rawModel = RawModel(
            isRecruiter: isRecruiter, user: null, recruiter: recruiter);

        CrudProvider.addUserToDB(rawModel);
        return rawModel;
      }
    } else {
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
          RawModel rawModel =
              RawModel(isRecruiter: isRecruiter, user: user, recruiter: null);

          CrudProvider.addUserToDB(rawModel);
          return rawModel;
        }
      } on FirebaseAuthException catch (e) {
        print(e.toString());
      }
    }

    return null;
  }

  Future<RawModel?> signInUser(String email, String password) async {
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

        final RawModel? rawModel =
            await CrudProvider.getUserFromDB(firebaseUser.uid);

        if (rawModel != null) {
          return rawModel;
        }
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
