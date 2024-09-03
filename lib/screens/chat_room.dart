import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_food/widgets/general_text_field.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chat with ${widget.user.name}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatId(currentUser.uuid, widget.user.uuid))
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == currentUser.uuid;
                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GeneralTextField(
              controller: _messageController,
              title: 'write a message here...',
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.send,
              validate: (value) {
                if (value!.trim().isEmpty) {
                  return 'Message cannot be empty';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                _sendMessage();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final currentUser = context.read<UserProvider>().user;
    final message = _messageController.text.trim();

    final chatId = getChatId(currentUser.uuid, widget.user.uuid);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': currentUser.uuid,
      'receiverId': widget.user.uuid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  String getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }
}
