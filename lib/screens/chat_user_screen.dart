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
      body: _buildUserList(context, currentUser),
    );
  }

  // Build the user list using StreamBuilder
  Widget _buildUserList(BuildContext context, UserModel currentUser) {
    return StreamBuilder<QuerySnapshot>(
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

        final users = _filterUsers(snapshot.data!.docs, currentUser);

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserTile(context, user);
          },
        );
      },
    );
  }

  // Filter users based on current user's role (Food Donor or NGO)
  List<UserModel> _filterUsers(
      List<QueryDocumentSnapshot<Object?>> docs, UserModel currentUser) {
    return docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((user) {
      return currentUser.isFoodDonor ? !user.isFoodDonor : user.isFoodDonor;
    }).toList();
  }

  // Build each ListTile for the user with enhanced design
  Widget _buildUserTile(BuildContext context, UserModel user) {
    return Card(
     color: Colors.green[100],
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8), // Spacing between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          user.name![0].toUpperCase() + user.name!.substring(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: _randomColor().withOpacity(0.1),
          child: Text(
            user.name![0].toUpperCase(),
            style: TextStyle(
              color: _randomColor(),
              fontSize: 18,
            ),
          ),
        ),
        trailing: _buildUserAvatar(context, user),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(user: user),
            ),
          );
        },
        subtitle: _buildUserSubtitle(user),
      ),
    );
  }

  // Build the user avatar (image or placeholder)
  Widget _buildUserAvatar(BuildContext context, UserModel user) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      backgroundImage:
          user.image != null ? MemoryImage(base64Decode(user.image!)) : null,
      child: user.image == null
          ? Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            )
          : null,
    );
  }

  // Build the user's subtitle with email and role (Food Donor or NGO)
  Widget _buildUserSubtitle(UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0), // Spacing between title and subtitle
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.email!,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            user.isFoodDonor ? "Food Donor" : "NGO",
            style: TextStyle(
              color: user.isFoodDonor ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Generate random color
  Color _randomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
