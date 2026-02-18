import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    // For this demo, we use the nearby/followed users as the active chat list
    final users = state.nearbyUsers; 
    
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: users.isEmpty 
        ? const Center(child: Text("Scan Nearby to find people to chat!"))
        : ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, i) {
            final u = users[i];
            return ListTile(
              // FIX: Use getAvatar to choose the right one based on mode
              leading: CircleAvatar(backgroundImage: NetworkImage(u.getAvatar(state.isFormal))),
              title: Text(u.username),
              subtitle: const Text("Tap to chat"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(targetUser: u.username))),
            );
          },
        ),
    );
  }
}