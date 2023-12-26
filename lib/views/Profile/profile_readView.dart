import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/utility/utility.dart';
import 'package:jobhunt_mobile/views/Pdf/pdfview.dart';
import 'package:jobhunt_mobile/views/Profile/profile_editView.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobhunt_mobile/model/userModel.dart';
import 'package:jobhunt_mobile/services/crudService.dart';

class ProfileReadView extends StatefulWidget {
  const ProfileReadView({Key? key}) : super(key: key);

  @override
  State<ProfileReadView> createState() => _ProfileReadViewState();
}

class _ProfileReadViewState extends State<ProfileReadView> {
  late Future<RawModel?> _userFuture;
  late Future<List<JobModel>> _jobFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = init();
    _jobFuture = initJobs();
  }

  Future<List<JobModel>> initJobs() async {
    return CrudProvider.getJobsByRecruiter(
        FirebaseAuth.instance.currentUser!.uid);
  }

  Future<RawModel?> init() async {
    return CrudProvider.getUserFromDB(FirebaseAuth.instance.currentUser!.uid);
  }

  UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RawModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching user data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available'));
          } else {
            RawModel raw = snapshot.data!;
            bool isRecruiter = raw.isRecruiter!;

            if (raw.isRecruiter == true) {
            } else {
              user = raw.user;
            }

            return raw!.isRecruiter == true
                ? ListView(
                    children: [
                      Container(
                        // height: 30.h,
                        width: 100.w,
                        padding: EdgeInsets.only(
                          left: 2.w,
                          right: 2.w,
                          bottom: 2.h,
                        ),
                        decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showAddJobDialog(context, raw);
                              },
                              icon: Icon(Icons.add),
                              label: Text("Add Job"),
                            ),
                            _buildJobsList(raw.recruiter!.id.toString()),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      Container(
                        // height: 30.h,
                        width: 100.w,
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          bottom: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton.filledTonal(
                                  isSelected: false,
                                  icon: const Icon(Icons.edit_outlined),
                                  selectedIcon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditProfileView();
                                        },
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        _userFuture = init();
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Profile updated'),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Image.asset(
                                          "assets/png/man_1.png",
                                          width: 100.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              user!.displayName!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user!.about!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            BaiscInfo(user: user!),
                            SizedBox(
                              height: 2.h,
                            ),
                            ContactInfo(user: user!),
                            SizedBox(
                              height: 2.h,
                            ),
                            SocialInfo(user: user!),
                            SizedBox(
                              height: 2.h,
                            ),
                            ResumeInfo(user: user!),
                            SizedBox(
                              height: 2.h,
                            ),
                            SkillsInfo(user: user!),
                          ],
                        ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }

  void _showAddJobDialog(BuildContext context, RawModel user) {
    TextEditingController jobNameController = TextEditingController();
    TextEditingController jobDescriptionController = TextEditingController();
    TextEditingController jobSkillsController = TextEditingController();
    TextEditingController jobSalaryController = TextEditingController();
    TextEditingController comapny = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Job'),
          content: SizedBox(
            width: 100.w,
            height: 40.h,
            child: Column(
              children: [
                TextField(
                  controller: jobNameController,
                  decoration: InputDecoration(labelText: 'Job Name'),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  controller: comapny,
                  decoration: InputDecoration(labelText: 'Company Name'),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  controller: jobDescriptionController,
                  decoration: InputDecoration(labelText: 'Job Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Process the job details here
                String jobName = jobNameController.text;
                String jobDescription = jobDescriptionController.text;
                String jobSkills = jobSkillsController.text;
                double jobSalary =
                    double.tryParse(jobSalaryController.text) ?? 0.0;

                // Generate new job data
                String newJobId =
                    UniqueKey().toString(); // Generate a unique ID
                String newJobLocation =
                    "Some Location"; // Set the location as needed

                // Create a new JobModel with the generated data
                JobModel newJob = JobModel(
                  id: newJobId,
                  title: jobName,
                  location: newJobLocation,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  company: comapny.text,
                  applyUrl: user.recruiter!.email!,
                  imageUrl: "",

                  // Add other properties as needed
                );

                CrudProvider.addJob(user, newJob);
                setState(() {
                  _jobFuture = initJobs();
                });
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  FutureBuilder<List<JobModel>> _buildJobsList(String recruiterId) {
    return FutureBuilder<List<JobModel>>(
      future: _jobFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error fetching jobs');
        } else {
          List<JobModel> jobs = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Text(
                'Jobs by Recruiter:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              for (var job in jobs)
                Card(
                  child: ListTile(
                    title: Text(job.title),
                    subtitle: Text(job.company),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete the job
                        CrudProvider.deleteJob(recruiterId, job.id);
                        setState(() {
                          _jobFuture = initJobs();
                        });
                      },
                    ),
                    onTap: () {
                      // Navigate to job details page
                    },

                    // Add other job details as needed
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}

class BaiscInfo extends StatelessWidget {
  const BaiscInfo({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 200.w,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    "Basic Information",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: Icon(
                    Icons.location_city,
                  ),
                  title: Row(
                    children: [
                      Text(
                        "Lives in ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user.city == ""
                            ? "No data"
                            : user.city! + " , " + user.country!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: Icon(
                    user.gender == "Male"
                        ? Icons.male_outlined
                        : Icons.female_outlined,
                  ),
                  title: Row(
                    children: [
                      Text(
                        "Gender ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user.gender == "" ? "No data" : user.gender!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: Icon(
                    Icons.date_range_outlined,
                  ),
                  title: Row(
                    children: [
                      Text(
                        "Date of Birth ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user.dob == ""
                            ? "No data"
                            : Utility.DateTimeToString(user.dob!),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 200.w,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    "Contact Information",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: Icon(
                    Icons.email_outlined,
                  ),
                  title: Row(
                    children: [
                      Text(
                        "Email ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user.email == "" ? "No data" : user.email!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: Icon(
                    Icons.phone_android_outlined,
                  ),
                  title: Row(
                    children: [
                      Text(
                        "Mobile ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user.phoneNumber == "" ? "No data" : user.phoneNumber!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SocialInfo extends StatelessWidget {
  const SocialInfo({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 200.w,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    "Social Information",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: FaIcon(FontAwesomeIcons.firefoxBrowser),
                  title: Row(
                    children: [
                      Text(
                        "Website ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user.websiteUrl == "" ? "No data" : user.websiteUrl!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: FaIcon(FontAwesomeIcons.github),
                  title: Row(
                    children: [
                      Text(
                        "Github ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        child: Text(
                          user.githubUrl == "" ? "" : user.githubUrl!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: FaIcon(FontAwesomeIcons.linkedin),
                  title: Row(
                    children: [
                      Text(
                        "LinkedIn ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        child: Text(
                          user.linkedinUrl == "" ? "" : user.linkedinUrl!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  iconColor: Theme.of(context).primaryColor,
                  leading: FaIcon(FontAwesomeIcons.twitter),
                  title: Row(
                    children: [
                      Text(
                        "Twitter ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        child: Text(
                          user.twitterUrl == "" ? "" : user.twitterUrl!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ResumeInfo extends StatelessWidget {
  const ResumeInfo({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 200.w,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    "Resume Information",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user!.resumeUrl == ""
                    ? Center(
                        child: Text("No data"),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfView(
                                pdfUrl: user!.resumeUrl!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 100.w,
                          height: 20.h,
                          child: Center(
                            child: FaIcon(FontAwesomeIcons.eye),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SkillsInfo extends StatelessWidget {
  const SkillsInfo({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 100.w,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    "Skills Information",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            user.skills.length > 0
                ? Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      for (var skill in user.skills)
                        ActionChip(
                          label: Text(skill!),
                          onPressed: () {},
                        ),
                    ],
                  )
                : Center(
                    child: Text("No data"),
                  ),
          ],
        ),
      ),
    );
  }
}
