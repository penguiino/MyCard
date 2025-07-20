import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;
  String? userPhoneNumber;
  String? userTitle;
  String? userAboutMe;
  String? _userPhotoUrl;
  String? selectedBackground;
  Map<String, String>? socialLinks;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController githubController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController instagramController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        final data = userDoc.data();
        if (data != null) {
          setState(() {
            userName = data['Full Name'] ?? user.displayName ?? 'John Doe';
            userEmail = data['Email'] ?? user.email ?? 'john.doe@example.com';
            userPhoneNumber = data['Phone Number'] ?? user.phoneNumber ?? '+1234567890';
            userTitle = data['Title'] ?? 'placeholder title';
            userAboutMe = data['About Me'] ?? '';
            socialLinks = Map<String, String>.from(data['Social Links'] ?? {});
            _userPhotoUrl = data['userPhotoUrl'] ?? 'assets/images/placeholder_image.jpg';
            selectedBackground = data['background'];

            nameController.text = userName!;
            emailController.text = userEmail!;
            phoneController.text = userPhoneNumber!;
            titleController.text = userTitle!;
            aboutMeController.text = userAboutMe!;
            githubController.text = socialLinks?['github'] ?? '';
            linkedinController.text = socialLinks?['linkedin'] ?? '';
            instagramController.text = socialLinks?['instagram'] ?? '';
          });
        } else {
          // fallback
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _saveChanges(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 100));
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'Full Name': nameController.text,
        'Email': emailController.text,
        'Phone Number': phoneController.text,
        'Title': titleController.text,
        'About Me': aboutMeController.text,
        'Social Links': {
          'github': githubController.text,
          'linkedin': linkedinController.text,
          'instagram': instagramController.text,
        },
        'background': selectedBackground,
        'userPhotoUrl': _userPhotoUrl,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Changes Saved'),
            content: Text('Your changes have been saved.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
    setState(() {
      userName = nameController.text;
      userEmail = emailController.text;
      userPhoneNumber = phoneController.text;
      userTitle = titleController.text;
      userAboutMe = aboutMeController.text;
      socialLinks = {
        'twitter': githubController.text,
        'linkedin': linkedinController.text,
        'instagram': instagramController.text,
      };
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _userPhotoUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Profile'),
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    GestureDetector(
    onTap: _pickImage,
    child: CircleAvatar(
    radius: 50.0,
      backgroundImage: _userPhotoUrl != null
          ? AssetImage(_userPhotoUrl!) as ImageProvider
          : AssetImage('assets/images/placeholder_image.jpg') as ImageProvider,
    ),
    ),
    SizedBox(width: 80),
    ElevatedButton(
    onPressed: () {
    _saveChanges(context);
    },
    child: Text('Save Changes'),
    ),
    ],
    ),
    SizedBox(height: 20),
    TextField(
    controller: nameController,
    decoration: InputDecoration(labelText: 'Name'),
    ),
    SizedBox(height: 20),
    TextField(
    controller: titleController,
    decoration: InputDecoration(labelText: 'Title'),
    ),
    SizedBox(height: 20),
    TextField(
    controller: phoneController,
    decoration: InputDecoration(labelText: 'Phone Number'),
    ),
    SizedBox(height: 20),
    TextField(
    controller: emailController,
    decoration: InputDecoration(labelText: 'Email'),
    ),
    SizedBox(height: 20),
    TextField(
    controller: aboutMeController,
    decoration: InputDecoration(labelText: 'About Me'),
    maxLines: null,
    ),
    SizedBox(height: 40),
    Text(
    'Social Links',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    TextField(
    controller: githubController,
    decoration: InputDecoration(labelText: 'Github',hintText:'enter your twitter URL'),
    ),
    TextField(
    controller: linkedinController,
    decoration: InputDecoration(labelText: 'LinkedIn',hintText:'enter your LinkedIn URL'),
    ),
    TextField(
    controller: instagramController,
    decoration: InputDecoration(labelText: 'Instagram',hintText:'enter your Instagram URL'),
    ),
    SizedBox(height: 40),
    Text(
    'Select Background Theme',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 20,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    ),
    itemBuilder
        : (context, index) {
      String imagePath = 'assets/images/backgrounds/background_$index.jpg';
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedBackground = imagePath;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedBackground == imagePath ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      );
    },
    ),
    ],
    ),
    ),
    );
  }
}
