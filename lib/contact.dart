import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ContactDetails.dart';

class ContactPage extends StatefulWidget {
  final String uid;

  ContactPage({required this.uid});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Stream<QuerySnapshot> _contactsStream;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    _contactsStream = FirebaseFirestore.instance
        .collection('users')
        .where('contacts', arrayContains: widget.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: const [
            SizedBox(
              width: 120,
              height: 0,
            ),
            Text(
              'Contacts',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Container(
              width: 390,
              height: 700,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: StreamBuilder<QuerySnapshot>(
                stream: _contactsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          var contact = snapshot.data?.docs[index];
                          var contactName = contact?.get('name') ?? '';
                          var contactImageUrl = contact?.get('imageUrl') ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactDetails(
                                    uid: widget.uid,
                                    contactName: contactName,
                                    contactImageUrl: contactImageUrl,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(40),
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(contactImageUrl),
                                  ),
                                  SizedBox(width: 30),
                                  Text(
                                    contactName,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
