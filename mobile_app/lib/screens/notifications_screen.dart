import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final items = await Provider.of<AppState>(context, listen: false).fetchNotifications();
    if(mounted) setState(() => _list = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: _list.isEmpty 
        ? const Center(child: Text("No notifications yet"))
        : ListView.builder(
            itemCount: _list.length,
            itemBuilder: (ctx, i) {
              final item = _list[i];
              return ListTile(
                leading: CircleAvatar(child: Icon(item.type == 'like' ? Icons.favorite : Icons.comment, color: Colors.white), backgroundColor: item.type == 'like' ? Colors.red : Colors.blue),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: item.fromUser, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " ${item.text}")
                    ]
                  ),
                ),
              );
            },
          ),
    );
  }
}