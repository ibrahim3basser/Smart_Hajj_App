import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowUserData extends StatefulWidget {
  ShowUserData({Key? key}) : super(key: key);

  @override
  State<ShowUserData> createState() => _ShowUserDataState();
}

class _ShowUserDataState extends State<ShowUserData> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('No Data');
        } else {
          var userData = snapshot.data!.data()!;
          String username = userData['name'] ?? 'No username';
          String imageUrl = userData['profilePicture'] ??
              'assets/default_profile_picture.png';

          return Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50,
                backgroundImage: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl)
                    : AssetImage(imageUrl) as ImageProvider<Object>?,
              ),
              const SizedBox(
                height: 2,
              ),
              SizedBox(
                height: 30,
                child: Text(
                  username,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
