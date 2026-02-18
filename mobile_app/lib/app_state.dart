import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'ble_service.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  final ApiService api = ApiService();
  final BleService ble = BleService();
  
  User? currentUser;
  bool isFormal = true; // Formal vs Casual Toggle
  List<Post> feed = [];
  List<dynamic> stories = [];
  List<User> nearbyUsers = [];

  void toggleMode() {
    isFormal = !isFormal;
    refresh();
  }

  Future<void> login(String u, String p) async {
    currentUser = await api.login(u, p);
    refresh();
  }

  Future<void> refresh() async {
    final data = await api.getFeed(isFormal ? "formal" : "casual");
    if (data.isNotEmpty) {
      feed = (data['posts'] as List).map((e) => Post.fromJson(e)).toList();
      stories = data['stories'] ?? [];
    }
    notifyListeners();
  }

  Future<void> createPost(String text, File? file, bool isStory) async {
    var req = http.MultipartRequest('POST', Uri.parse('${ApiService.baseUrl}/content/create'));
    req.fields['username'] = currentUser!.username;
    req.fields['text'] = text;
    req.fields['mode'] = isFormal ? "formal" : "casual";
    req.fields['type'] = isStory ? "story" : "post";
    
    if (file != null) {
      req.files.add(await http.MultipartFile.fromPath('file', file.path));
    }
    await req.send();
    refresh();
  }

  // ... inside AppState class ...

  Future<void> toggleLike(String postId) async {
    // Optimistic update can be done here, but for simplicity we just call API and refresh
    await api.interactPost(postId, currentUser!.username, 'like');
    refresh(); // Refresh feed to show new like count
  }

  Future<void> addComment(String postId, String text) async {
    await api.interactPost(postId, currentUser!.username, 'comment', comment: text);
    refresh();
  }

  Future<List<NotificationItem>> fetchNotifications() async {
    if (currentUser == null) return [];
    return await api.getNotifications(currentUser!.username);
  }

// ... existing code ...

  // Combines Bluetooth Scanning with Server verification
  void scanNearby() async {
    await ble.init();
    // In a real app, we would scan BLE UUIDs. 
    // For this demo, we simulate the BLE latency and then fetch from server 
    // to ensure reliable discovery on all device types.
    await Future.delayed(const Duration(seconds: 2));
    
    final allUsers = await api.getNearby();
    
    // Remove myself
    nearbyUsers = allUsers.where((u) => u.username != currentUser?.username).toList();
    notifyListeners();
  }
}