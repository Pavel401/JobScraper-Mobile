import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt_mobile/model/userModel.dart';
import 'package:jobhunt_mobile/services/crudService.dart';
import 'package:jobhunt_mobile/utility/utility.dart';
import 'package:jobhunt_mobile/widgets/movingDots.dart';
import 'package:sizer/sizer.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _cityController = TextEditingController(text: "");
  TextEditingController _countryController = TextEditingController(text: "");
  TextEditingController _genderController = TextEditingController(text: "");
  TextEditingController _dobController = TextEditingController(text: "");
  TextEditingController _displayNameController =
      TextEditingController(text: "");
  TextEditingController _aboutController = TextEditingController(text: "");
  TextEditingController _stateController = TextEditingController(text: "");
  TextEditingController _phoneController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _websiteController = TextEditingController(text: "");
  TextEditingController _githubController = TextEditingController(text: "");
  TextEditingController _twitterController = TextEditingController(text: "");
  TextEditingController _linkedinController = TextEditingController(text: "");
  TextEditingController _resumeController = TextEditingController(text: "");
  TextEditingController _skillController = TextEditingController(text: "");

  List<String> _skills = [];
  UserModel? user;
  late Future<RawModel?> _userFuture;
  DateTime? pickedDate;

  bool isSaving = false;
  bool shouldRebuild = true;
  void initState() {
    super.initState();
    _userFuture = init();
  }

  Future<RawModel?> init() async {
    return CrudProvider.getUserFromDB(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding edit profile view");
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: FutureBuilder<RawModel?>(
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

                UserModel user = raw.user!;

                if (shouldRebuild) {
                  _cityController =
                      TextEditingController(text: user.city ?? '');
                  _countryController =
                      TextEditingController(text: user.country ?? '');
                  _genderController =
                      TextEditingController(text: user.gender ?? '');
                  _dobController = TextEditingController(
                      text: Utility.DateTimeToString(user.dob) ?? '');
                  _displayNameController =
                      TextEditingController(text: user.displayName ?? '');
                  _aboutController =
                      TextEditingController(text: user.about ?? '');
                  _stateController =
                      TextEditingController(text: user.state ?? '');
                  _phoneController = TextEditingController(
                      text: "" + user.phoneNumber.toString() ?? '');
                  _emailController =
                      TextEditingController(text: user.email ?? '');
                  _websiteController =
                      TextEditingController(text: user.websiteUrl ?? '');
                  _githubController =
                      TextEditingController(text: user.githubUrl ?? '');
                  _twitterController =
                      TextEditingController(text: user.twitterUrl ?? '');
                  _linkedinController =
                      TextEditingController(text: user.linkedinUrl ?? '');
                  _resumeController =
                      TextEditingController(text: user.resumeUrl ?? '');
                  List<String> _Tempskills = List.from(user.skills!);
                  _skills = _Tempskills + _skills;

                  shouldRebuild = false;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: InputDecoration(labelText: 'Display Name'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.length < 3) {
                            return 'Please enter a display name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(labelText: 'City'),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Please enter a valid city';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(labelText: 'Country'),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Please enter a valid country';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(labelText: 'Gender'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value != "Male" ||
                              value != "Female" ||
                              value != "Other") {
                            return 'Enter a valid gender Male/Female/Other';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(labelText: 'Date of Birth'),
                        onTap: () async {
                          // Show date picker
                          pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          // Update the controller's text with the formatted date
                          if (pickedDate != null) {
                            _dobController.text =
                                Utility.DateTimeToString(pickedDate!) ?? '';
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _aboutController,
                        maxLines: 5,
                        maxLength: 300,
                        minLines: 1,
                        decoration: InputDecoration(labelText: 'About Me'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.length < 10) {
                            return 'Please enter a valid bio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(labelText: 'State'),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Please enter a valid state';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid phone number starting with +91';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.length < 5) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _websiteController,
                        decoration: InputDecoration(labelText: 'Website URL'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.length < 10) {
                            return 'Please enter a valid website URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _githubController,
                        decoration: InputDecoration(labelText: 'GitHub URL'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.contains("github.com") ||
                              value.length < 10) {
                            return 'Please enter a valid github URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _twitterController,
                        decoration: InputDecoration(labelText: 'Twitter URL'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.contains("twitter") ||
                              value.length < 10) {
                            return 'Please enter a valid twitter URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _linkedinController,
                        decoration: InputDecoration(labelText: 'LinkedIn URL'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == '' ||
                              value.contains("linkedin.com") ||
                              value.length < 10) {
                            return 'Please enter a valid linkedin URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _resumeController,
                        decoration: InputDecoration(labelText: 'Resume URL'),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Please enter a valid resume URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Skills",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      skillsWidget(),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                setState(() {
                                  isSaving = true;
                                });

                                // Update the user information
                                UserModel updatedUser = UserModel(
                                  id: user.id,
                                  email: _emailController.text,
                                  displayName: _displayNameController.text,
                                  photoUrl: user.photoUrl,
                                  createdAt: user.createdAt,
                                  dob: pickedDate ?? user.dob,
                                  gender: _genderController.text,
                                  phoneNumber: _phoneController.text,
                                  address: user.address,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  country: _countryController.text,
                                  pincode: user.pincode,
                                  about: _aboutController.text,
                                  resumeUrl: _resumeController.text,
                                  githubUrl: _githubController.text,
                                  linkedinUrl: _linkedinController.text,
                                  twitterUrl: _twitterController.text,
                                  websiteUrl: _websiteController.text,
                                  skills: _skills,
                                  tokens: user.tokens,
                                );

                                try {
                                  RawModel raw = RawModel(
                                      user: updatedUser,
                                      isRecruiter: false,
                                      recruiter: null);
                                  await CrudProvider.updateUserInDB(raw);

                                  Navigator.pop(context);
                                  // setState(() {
                                  //   isSaving = false;
                                  // });
                                } catch (e) {
                                  print('Error saving data: $e');
                                } finally {
                                  setState(() {
                                    isSaving = false;
                                  });
                                }
                                // }
                              },
                        child: isSaving
                            ? SizedBox(
                                width: 30.w,
                                child: Center(
                                  child: JumpingDots(
                                    color: Theme.of(context).primaryColor,
                                    radius: 10,
                                    numberOfDots: 3,
                                  ),
                                ),
                              )
                            : Text('Save Changes'),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget skillsWidget() {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        ..._skills.map((skill) {
          return Chip(
            label: Text(skill),
            onDeleted: () {
              setState(() {
                _skills.remove(skill);
              });
            },
          );
        }).toList(),
        Chip(
          label: Text('Add a skill'),
          backgroundColor: Colors.grey[300],
          deleteIcon: Icon(Icons.add),
          onDeleted: () {
            // Show a dialog for the user to add a new skill
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String newSkill = "";

                return AlertDialog(
                  title: Text('Add a New Skill'),
                  content: TextField(
                    onChanged: (value) {
                      newSkill = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a new skill',
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
                        setState(() {
                          _skills.add(newSkill);
                          newSkill = "";
                        });

                        Navigator.of(context).pop();
                        print(_skills);
                      },
                      child: Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
