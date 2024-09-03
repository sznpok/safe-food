import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'chat_room.dart';

class ChatUsersScreen extends StatelessWidget {
  const ChatUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs
              .map((doc) =>
                  UserModel.fromJson(doc.data() as Map<String, dynamic>))
              .where((user) {
            if (currentUser.isFoodDonor) {
              // If the current user is a food donor, show only NGOs
              return !user.isFoodDonor;
            } else {
              // If the current user is an NGO, show only food donors
              return user.isFoodDonor;
            }
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                title:
                    Text(user.name![0].toUpperCase() + user.name!.substring(1)),
                leading: CircleAvatar(
                  backgroundColor: randomColor().withOpacity(0.1),
                  child: Text(
                    user.name![0].toUpperCase(),
                    style: TextStyle(
                      color: randomColor(),
                    ),
                  ),
                ),
                trailing: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  backgroundImage: user.image != null
                      ? MemoryImage(base64Decode(user.image!))
                      : null,
                  child: user.image == null
                      ? Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(user: user),
                    ),
                  );
                },
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email!),
                    Text(
                      user.isFoodDonor ? "Food Donor" : "NGO",
                      style: TextStyle(
                          color: user.isFoodDonor ? Colors.green : Colors.red),
                    ),
                  ],
                ), // Replace 'email' with your field
              );
            },
          );
        },
      ),
    );
  }

  // Generate random color
  Color randomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
