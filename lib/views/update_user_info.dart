import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hajj_app/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateUserProfile extends StatefulWidget {
  static String id = 'update_user_profile';

  const UpdateUserProfile({super.key});
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    File? pickedFile = await UserService.pickImage();
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _updateUserData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String userId = _auth.currentUser!.uid;
      String newUsername = _usernameController.text;
      String newEmail = _emailController.text;

      UserService().updateUserInfo(userId, newEmail, {
        'name': newUsername,
        'email': newEmail,
        // Add other fields to update here
      }, _imageFile).then((_) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated successfully')));
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user information: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found'));
          } else {
            var userData = snapshot.data!.data()!;
            _usernameController.text = userData['name'] ?? '';
            _emailController.text = userData['email'] ?? '';
            String profilePicture = userData['profilePicture'] ?? 'assets/default_profile_picture.png';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (profilePicture.startsWith('http')
                          ? NetworkImage(profilePicture)
                          : AssetImage(profilePicture)) as ImageProvider,
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Change Photo'),
                      onPressed: _pickImage,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _updateUserData,
                            child: Text('Update Profile'),
                          ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}