import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
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

  static Future<void> addJob(RawModel user, JobModel job) async {
    await usersCollection
        .doc(user.recruiter!.id)
        .collection("jobs")
        .doc(job.id) // Using job.id as the document ID
        .set(job.toJson());
  }

  static Future<List<JobModel>> getJobsByRecruiter(String recruiterId) async {
    QuerySnapshot jobSnapshot =
        await usersCollection.doc(recruiterId).collection("jobs").get();

    List<JobModel> jobs = jobSnapshot.docs
        .map((doc) => JobModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return jobs;
  }

  static Future<List<JobModel>> getJobsForAllRecruiters() async {
    QuerySnapshot recruiterSnapshot =
        await usersCollection.where("isRecruiter", isEqualTo: true).get();

    List<JobModel> allJobs = [];

    for (QueryDocumentSnapshot recruiterDoc in recruiterSnapshot.docs) {
      String recruiterId = recruiterDoc.id;
      QuerySnapshot jobSnapshot =
          await usersCollection.doc(recruiterId).collection("jobs").get();

      List<JobModel> jobs = jobSnapshot.docs
          .map((doc) => JobModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      allJobs.addAll(jobs);
    }

    return allJobs;
  }

  static Future<void> deleteJob(String recruiterId, String jobId) async {
    await usersCollection
        .doc(recruiterId)
        .collection("jobs")
        .doc(jobId)
        .delete();
  }

  static Future<void> updateJob(
      String recruiterId, String jobId, JobModel updatedJob) async {
    await usersCollection
        .doc(recruiterId)
        .collection("jobs")
        .doc(jobId)
        .update(updatedJob.toJson());
  }
}
