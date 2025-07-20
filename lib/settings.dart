// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
/*import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';*/

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                'settings',
                style: TextStyle(fontSize: 30),
              ),
            ],
          )
      ),

      body: SingleChildScrollView(
        child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: SizedBox(
                      width: 150,
                      height: 100,
                      child: Image.asset('assets/images/logo.png')),
                ),
              ),

              SizedBox(
                height: 120,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: SizedBox(
              height: 60,
              width: 450,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                   ),
                  child: Text('Account Settings',style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountSettings(),
                      ),
                    );
                  }
              ),
            ),
              ),

              SizedBox(
                height: 50,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: SizedBox(
                  height: 60,
                  width: 450,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      child: Text('sign out',style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      }
                  ),
                ),
              ),

            ],
          ),
        ),
    );
  }
}

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          ListTile(
            title: Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Delete account'),
            onTap: () {
              Navigator.push(
              context,
                MaterialPageRoute(
                  builder: (context) => AccountDeletion(),
                ),
              );
             },
          ),
        ],
      ),
    );
  }
}


class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<void> _changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var credentials = await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: _passwordController.text,
          ),
        );
        if (credentials != null) {
          await user.updatePassword(_newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password changed successfully.'),
          ));
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password.';
                  }
                  return null;
                },
              ),
              SizedBox(width: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password.';
                  }
                  return null;
                },
              ),
              SizedBox(width: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              if (_error != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(width: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword();
                  }
                },
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AccountDeletion extends StatelessWidget {
  void _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      print('Error deleting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _deleteAccount(context),
              child: Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
