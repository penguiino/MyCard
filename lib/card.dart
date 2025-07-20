import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  String? _userName;
  String? _userEmail;
  String? _userTitle;
  String? _userNumber;
  String? _userPhotoUrl;
  String? _userBackground;
  String? _userAboutMe;
  String? _githubUrl;
  String? _linkedinUrl;
  String? _instagramUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        print('User UID: ${user.uid}');

        final data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          final socialLinks = Map<String, String>.from(data['Social Links'] ?? {});
          setState(() {
            _userName = data['Full Name'] ?? 'Name not available';
            _userTitle = data['Title'] ?? 'Title not available';
            _userEmail = user.email;
            _userNumber = data['Phone Number'] ?? 'Number not available';
            _userPhotoUrl = user.photoURL ?? 'assets/images/placeholder_image.jpg';
            _userBackground = data['background'] ?? 'assets/images/background_placeholder.jpg';
            _userAboutMe = data['About Me'] ?? 'About me not available';
            _githubUrl = socialLinks['github'] ?? '';
            _linkedinUrl = socialLinks['linkedin'] ?? '';
            _instagramUrl = socialLinks['instagram'] ?? '';
          });
        } else {
          print('Document data is null');
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }


  Future<void> _launchURL(String url, String platform) async {
    if (url.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No $platform URL'),
            content: Text('Please add your $platform link in the profile page.'),
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
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _shareQRCode() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String qrData = user.uid;
        Uint8List qrBytes = utf8.encode(qrData) as Uint8List;
        String base64QrData = base64Encode(qrBytes);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Share QR Code'),
              content: SizedBox(
                width: 250.0,
                height: 250.0,
                child: Container(
                  child: QrImageView(
                    data: base64QrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Error sharing QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Column(
          children: [
            SizedBox(
              width: 120,
              height: 0,
            ),
            Text(
              'Home',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScanPage()),
                );
              },
              child: const Text('Add a new contact'),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Container(
                  width: 390,
                  height: 280,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    image: _userBackground != null
                        ? DecorationImage(
                      image: AssetImage(_userBackground!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: _userPhotoUrl != null
                                  ? FileImage(File(_userPhotoUrl!)) as ImageProvider
                                  : Image.asset('assets/images/placeholder_image.jpg').image,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName ?? 'John Doe',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 4),
                                child: Icon(
                                  FontAwesomeIcons.user,
                                  size: 20,
                                  color: Colors.purple,
                                ),
                              ),
                              Text(
                                _userTitle ?? 'Title placeholder',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 4),
                                child: Icon(
                                  FontAwesomeIcons.phone,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _userNumber ?? 'number placeholder',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 4),
                                child: Icon(
                                  FontAwesomeIcons.envelope,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _userEmail ?? 'email placeholder',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: () {
                                    _launchURL(_githubUrl ?? '', 'GitHub');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.github,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: () {
                                    _launchURL(_linkedinUrl ?? '', 'LinkedIn');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.linkedin,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: () {
                                    _launchURL(_instagramUrl ?? '', 'Instagram');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.instagram,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: _shareQRCode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.qrcode,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Container(
                width: 390,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent[100],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Me',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _userAboutMe ?? 'Share something about yourself with the world.',
                        style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: GlobalKey(),
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        _checkContactExistence(scanData.code);
      }
    });
  }

  void _checkContactExistence(String? contactUID) async {
    if (contactUID == null) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = userDoc.data() as Map<String, dynamic>?;
        List<dynamic> contacts = data?['contacts'] ?? [];
        if (!contacts.contains(contactUID)) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'contacts': FieldValue.arrayUnion([contactUID]),
          });
        }
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error checking contact existence: $e');
        // Handle error
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


