import 'package:flutter/material.dart';
import 'package:myapp/screens/chat.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/chat/chat_service.dart';

import '../widgets/user_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void signOut() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
              onPressed: signOut, icon: const Icon(Icons.logout_outlined))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
              'There might be some problem. Please try again later!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Conversation loading...");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData['email'],
          userImage: userData['profileImage'],
          onTap: () {
            // Navigate to chat screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                  userImage: userData['profileImage'],
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}
