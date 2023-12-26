import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/model/jobModel.dart';
import 'package:jobhunt_mobile/model/userModel.dart';
import 'package:jobhunt_mobile/services/crudService.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanySpecificJobs extends StatefulWidget {
  const CompanySpecificJobs({super.key});

  @override
  State<CompanySpecificJobs> createState() => _CompanySpecificJobsState();
}

class _CompanySpecificJobsState extends State<CompanySpecificJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Opportunities'),
      ),
      body: FutureBuilder<List<JobModel>>(
        future: CrudProvider.getJobsForAllRecruiters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<JobModel> allJobs = snapshot.data ?? [];

            return ListView.builder(
              itemCount: allJobs.length,
              itemBuilder: (context, index) {
                JobModel job = allJobs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyScreen(job: job),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(job.title),
                      subtitle: Text(job.company),
                      // Add more details or customize the ListTile as needed
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ApplyScreen extends StatefulWidget {
  final JobModel job;

  ApplyScreen({required this.job});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  RawModel? rawModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    rawModel = await CrudProvider.getUserFromDB(
        FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for ${widget.job.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Job Title:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.job.title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Company:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.job.company,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Job Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.job.location,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _launchEmailApp(widget.job, rawModel!.user!);
              },
              child: Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmailApp(JobModel job, UserModel user) async {
    String subject = 'Applying for ${job.title}';
    String body = '''
      Dear Hiring Team,

      I am interested in applying for the position of ${job.title} at ${job.company}.
      
      Candidate Details:
      Name: ${user.displayName}
      About: ${user.about ?? 'N/A'}
      

      Email: ${user.email}
      Skills: ${user.skills.join(', ')}

      Resume: ${user.resumeUrl ?? 'N/A'}
      
      Github: ${user.githubUrl ?? 'N/A'}
      LinkedIn: ${user.linkedinUrl ?? 'N/A'}
      Twitter: ${user.twitterUrl ?? 'N/A'}
      Website: ${user.websiteUrl ?? 'N/A'}
      
      Phone Number: ${user.phoneNumber ?? 'N/A'}
      Address: ${user.address ?? 'N/A'}
      City: ${user.city ?? 'N/A'}
      State: ${user.state ?? 'N/A'}
      Country: ${user.country ?? 'N/A'}
      Pincode: ${user.pincode ?? 'N/A'}
      
      Sincerely,
      ${user.displayName}
  ''';

    final url = Uri.parse(
        'mailto:${job.applyUrl}?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
