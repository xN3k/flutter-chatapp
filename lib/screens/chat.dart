import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/chat/chat_service.dart';
import 'package:myapp/widgets/chat_bubble.dart';
import 'package:myapp/widgets/custom_textfield.dart';

class ChatScreen extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  final String? userImage;

  ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.userImage,
  });

  final TextEditingController _messageController = TextEditingController();

  // instances
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // method to send messages
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25, // Adjust size as needed
              backgroundColor: Colors.grey[300], // Fallback background color
              backgroundImage: userImage != null
                  ? NetworkImage(userImage!) // Load image from the URL
                  : null, // No image
              child: userImage == null
                  ? Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey[600], // Icon color
                    )
                  : null, // Show icon if no image
            ),
            SizedBox(width: 16.0 * 0.75),
            Text(receiverEmail),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList());
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
        ],
      ),
    );
  }

  // input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, right: 16, left: 16),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfield(hintText: 'Enter Message'),
          ),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
