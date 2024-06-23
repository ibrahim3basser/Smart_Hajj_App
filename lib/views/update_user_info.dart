// import 'package:flutter/material.dart';
// import 'package:hajj_app/services/user_service.dart';


// class UserProfilePage extends StatefulWidget {
//   final String userId;
//   static  String id = 'UserProfilePage';

//   const UserProfilePage({Key? key, required this.userId}) : super(key: key);

//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   final UserService _userService = UserService();
//   String _newUsername = '';
//   String _newEmail = '';
//  void _updateUserInfo() {
//     // Call the updateUserInfo method with the new data
//     _userService.updateUserInfo(widget.userId,  _newEmail , {
//       'name': _newUsername,
//       'email': _newEmail,
//       // Add other fields to update here
//     }).then((_) {
//       // Handle success
//       print('User information updated successfully.');
//     }).catchError((error) {
//       // Handle error
//       print('Error updating user information: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Update User Information', style: TextStyle(fontSize: 20)),
//             TextField(
//               onChanged: (value) => _newUsername = value,
//               decoration: InputDecoration(labelText: 'New Username'),
//             ),
//             TextField(
//               onChanged: (value) => _newEmail = value,
//               decoration: InputDecoration(labelText: 'New Email'),
//             ),
//             ElevatedButton(
//               onPressed: _updateUserInfo
//               ,
              
//               child: Text('Update'),
              
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//---------------------------------------------------------------------------------------------

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:hajj_app/services/user_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class UpdateUserProfile extends StatefulWidget {
//   static  String id = 'update_user_profile';

//   const UpdateUserProfile({super.key});
//   @override
//   _UpdateUserProfileState createState() => _UpdateUserProfileState();
// }

// class _UpdateUserProfileState extends State<UpdateUserProfile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   File? _imageFile;
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     File? pickedFile = await UserService.pickImage();
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile;
//       });
//     }
//   }



   

//   void _updateUserData() {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       String userId = _auth.currentUser!.uid;
//       String newUsername = _usernameController.text;
//       String newEmail = _emailController.text;

//       UserService().updateUserInfo(userId, newEmail, {
//         'name': newUsername,
//         'email': newEmail,
//         // Add other fields to update here
//       }, _imageFile).then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated successfully')));
//       }).catchError((error) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user information: $error')));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String userId = _auth.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(title: Text('Update Profile')),
//       body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading user data'));
//           } else if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('No user data found'));
//           } else {
//             var userData = snapshot.data!.data()!;
//             _usernameController.text = userData['name'] ?? '';
//             _emailController.text = userData['email'] ?? '';
//             String profilePicture = userData['profilePicture'] ?? 'assets/default_profile_picture.png';

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!)
//                           : (profilePicture.startsWith('http')
//                               ? NetworkImage(profilePicture)
//                               : AssetImage(profilePicture)) as ImageProvider,
//                     ),
//                     TextButton.icon(
//                       icon: Icon(Icons.camera_alt),
//                       label: Text('Change Photo'),
//                       onPressed: _pickImage,
//                     ),
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(labelText: 'Username'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a username';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: InputDecoration(labelText: 'Email'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter an email';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     _isLoading
//                         ? CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: _updateUserData,
//                             child: Text('Update Profile'),
//                           ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:hajj_app/services/user_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class UpdateUserProfile extends StatefulWidget {
//   static String id = 'update_user_profile';

//   const UpdateUserProfile({super.key});
//   @override
//   _UpdateUserProfileState createState() => _UpdateUserProfileState();
// }

// class _UpdateUserProfileState extends State<UpdateUserProfile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   File? _imageFile;
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     File? pickedFile = await UserService.pickImage();
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile;
//       });
//     }
//   }

//   void _updateUserData() {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       String userId = _auth.currentUser!.uid;
//       String newUsername = _usernameController.text;
//       String newEmail = _emailController.text;

//       UserService().updateUserInfo(userId, newEmail, {
//         'name': newUsername,
//         'email': newEmail,
//         // Add other fields to update here
//       }, _imageFile).then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated successfully')));
//       }).catchError((error) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user information: $error')));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String userId = _auth.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(title: Text('Update Profile')),
//       body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading user data'));
//           } else if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('No user data found'));
//           } else {
//             var userData = snapshot.data!.data()!;
//             _usernameController.text = userData['name'] ?? '';
//             _emailController.text = userData['email'] ?? '';
//             String profilePicture = userData['profilePicture'] ?? 'assets/default_profile_picture.png';

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       //backgroundImage: AssetImage(profilePicture) as ImageProvider,

//                       backgroundImage: _imageFile != null
//                         ? FileImage(_imageFile!)
//                         : (profilePicture.startsWith('http')
//                           ? NetworkImage(profilePicture)
//                           : AssetImage(profilePicture)) as ImageProvider,
//                     ),
//                     TextButton.icon(
//                       icon: Icon(Icons.camera_alt),
//                       label: Text('Change Photo'),
//                       onPressed: _pickImage,
//                     ),
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(labelText: 'Username'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a username';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: InputDecoration(labelText: 'Email'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter an email';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     _isLoading
//                         ? CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: _updateUserData,
//                             child: Text('Update Profile'),
//                           ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hajj_app/services/user_service.dart';
// import 'dart:io';

// class UpdateUserProfile extends StatefulWidget {
//   static String id = 'update_user_profile';

//   const UpdateUserProfile({super.key});
//   @override
//   _UpdateUserProfileState createState() => _UpdateUserProfileState();
// }

// class _UpdateUserProfileState extends State<UpdateUserProfile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   File? _imageFile;
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     File? pickedFile = await UserService.pickImage();
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile;
//       });
//     }
//   }

//   void _updateUserData() {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       String userId = _auth.currentUser!.uid;
//       String newUsername = _usernameController.text;
//       String newEmail = _emailController.text;

//       UserService().updateUserInfo(userId, newEmail, {
//         'name': newUsername,
//         'email': newEmail,
//         // Add other fields to update here
//       }, _imageFile).then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated successfully')));
//       }).catchError((error) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user information: $error')));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String userId = _auth.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Profile'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading user data'));
//           } else if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('No user data found'));
//           } else {
//             var userData = snapshot.data!.data()!;
//             _usernameController.text = userData['name'] ?? '';
//             _emailController.text = userData['email'] ?? '';
//             String profilePicture = userData['profilePicture'] ?? 'assets/default_profile_picture.png';

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     Center(
//                       child: Stack(
//                         children: [
//                           CircleAvatar(
//                             radius: 50,
//                             backgroundImage: _imageFile != null
//                                 ? FileImage(_imageFile!)
//                                 : (profilePicture.startsWith('http')
//                                     ? NetworkImage(profilePicture)
//                                     : AssetImage(profilePicture)) as ImageProvider,
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: GestureDetector(
//                               onTap: _pickImage,
//                               child: CircleAvatar(
//                                 radius: 20,
//                                 backgroundColor: Colors.white,
//                                 child: Icon(Icons.camera_alt, color: Colors.grey.shade700),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         labelText: 'Username',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.person),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a username';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.email),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter an email';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     _isLoading
//                         ? Center(child: CircularProgressIndicator())
//                         : ElevatedButton(
//                             onPressed: _updateUserData,
//                             child: Text('Update Profile'),
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               textStyle: TextStyle(fontSize: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajj_app/services/user_service.dart';
import 'dart:io';

import 'package:hajj_app/widgets/custom_button.dart';

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
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String userId = _auth.currentUser!.uid;
        String newUsername = _usernameController.text;
        String newEmail = _emailController.text;

        await UserService().updateUserInfo(userId, newEmail, {
          'name': newUsername,
          'email': newEmail,
          // Add other fields to update here
        }, _imageFile);

        if (_newPasswordController.text.isNotEmpty) {
          await _updatePassword();
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User information updated successfully')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user information: $error')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updatePassword() async {
    User? user = _auth.currentUser;

    try {
      String email = user!.email!;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: _currentPasswordController.text);

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating password: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصى '),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found'));
          } else {
            var userData = snapshot.data!.data()!;
            _usernameController.text = userData['name'] ?? '';
            _emailController.text = userData['email'] ?? '';
            String profilePicture = userData['profilePicture'] ?? 'assets/default_profile_picture.png';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (profilePicture.startsWith('http')
                                    ? NetworkImage(profilePicture)
                                    : AssetImage(profilePicture)) as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.camera_alt, color: Colors.grey.shade700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الالكترونى',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'برجاء ادخال البريد الالكترونى';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'الرقم السرى الحالى',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'الرقم السرى الجديد',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد الرقم السرى',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : 
                        CustomButton(text: 'تعديل', onTap: _updateUserData,)
                      
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



