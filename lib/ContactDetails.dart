import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactDetails extends StatelessWidget {
  final String uid;
  final String contactName;
  final String contactTitle;
  final String contactPhoneNumber;
  final String contactEmail;
  final String contactImageUrl;

  const ContactDetails({
    Key? key,
    required this.uid,
    required this.contactName,
    required this.contactImageUrl,
    this.contactTitle = '',
    this.contactPhoneNumber = '',
    this.contactEmail = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
                child: Container(
                  width: 390,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
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
                              backgroundImage: NetworkImage(contactImageUrl),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contactName,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                contactTitle,
                                style: const TextStyle(fontSize: 16),
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
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0, right: 4),
                                    child: Icon(
                                      FontAwesomeIcons.phone,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    contactPhoneNumber,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
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
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                contactEmail,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
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
