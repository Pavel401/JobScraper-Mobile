import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    foregroundImage: AssetImage('assets/png/icon.png'),
                    radius: 52,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Text(
                    'JobHunt',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                    wordSpacing: 3,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "Welcome to JobHunt Mobile – Your Ultimate Job Search Companion!\n\n",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text:
                          "JobHunt Mobile is a cutting-edge mobile application meticulously crafted to elevate your job-seeking journey. Built with Flutter, an open-source framework, JobHunt Mobile brings job opportunities to your fingertips, empowering you to stay connected and in control of your career.\n\n",
                    ),
                    TextSpan(
                      text: "Key Features:\n",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    TextSpan(
                      text:
                          "🚀 Convenience on the Go: Access and manage job postings anytime, anywhere.\n"
                          "🔍 Effortless Browsing: Explore a vast array of job opportunities with intuitive navigation.\n"
                          "🎯 Smart Filtering: Refine your search based on preferences and criteria that matter to you.\n"
                          "🌐 Real-time Updates: Stay informed with the latest job postings scraped by our advanced Jobs Scraper.\n\n",
                    ),
                    TextSpan(
                      text:
                          "Whether you're a coding enthusiast or a content writing enthusiast, JobHunt Mobile caters to your dynamic needs. Take charge of your career path with a tool designed for efficiency and effectiveness.\n\n",
                    ),
                    TextSpan(
                      text:
                          "Download JobHunt Mobile now and embark on a journey towards your dream job! Your success story begins here.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Made with 💙 by',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      wordSpacing: 3,
                      letterSpacing: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _launchGitHub();
                    },
                    child: Text(
                      'Mabud Alam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchGitHub() async {
    const githubUrl = 'https://github.com/Pavel401';
    // ignore: deprecated_member_use
    if (await canLaunch(githubUrl)) {
      // ignore: deprecated_member_use
      await launch(githubUrl);
    } else {
      throw 'Could not launch $githubUrl';
    }
  }
}
