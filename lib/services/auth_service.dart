import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProfilePicture(String userId, File? imageFile) async {
    try {
      if (imageFile != null) {
        Reference storageReference = _storage.ref().child('profilePictures/$userId');
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        return downloadURL;
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
    return null;
  }

   // Function to pick image from gallery
  void pickImage(Function(File) onImagePicked) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        onImagePicked(File(pickedImage.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> registerUser(String name, String email, String password, File? profileImage) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? profileImageUrl = await uploadProfilePicture(userCredential.user!.uid, profileImage);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'profileImageUrl': profileImageUrl,
        // Add other user details here
      });
    } catch (e) {
      print('Error registering user: $e');
      throw e; // Propagate the error for handling in UI
    }
  }

  // Other authentication-related functions...
}
