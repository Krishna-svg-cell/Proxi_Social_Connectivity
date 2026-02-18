import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  // ----------------------------------------------------
  // TODO: REPLACE THIS IP WITH YOUR LAPTOP'S WI-FI IP
  // ----------------------------------------------------
  static const String _ip = "10.202.243.190";

  static const String baseUrl = "http://$_ip:8000";
  String get wsUrl => "ws://$_ip:8000";

  Future<User?> login(String u, String p) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/auth/login'),
          body: {"username": u, "password": p});
      return User.fromJson(jsonDecode(res.body)['user']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getFeed(String mode) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/feed?mode=$mode'));
      return jsonDecode(res.body);
    } catch (e) {
      return {};
    }
  }

  Future<List<User>> getNearby() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/users/nearby'));
      return (jsonDecode(res.body) as List)
          .map((e) => User.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> follow(String me, String target) async {
    await http.post(Uri.parse('$baseUrl/user/follow'),
        body: {"me": me, "target": target});
  }

  Future<void> interactPost(String id, String username, String action,
      {String? comment}) async {
    await http.post(Uri.parse('$baseUrl/post/interact'), body: {
      "id": id,
      "username": username,
      "action": action,
      if (comment != null) "comment": comment
    });
  }

  // NEW: Send Direct Message (used for Story Replies)
  Future<void> sendDirectMessage(
      String sender, String receiver, String text) async {
    await http.post(Uri.parse('$baseUrl/chat/send_http'),
        body: {"sender": sender, "receiver": receiver, "text": text});
  }

  Future<List<NotificationItem>> getNotifications(String username) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/notifications/$username'));
      List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => NotificationItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getChatHistory(String u1, String u2) async {
    final res = await http.get(Uri.parse('$baseUrl/chat/history/$u1/$u2'));
    return jsonDecode(res.body);
  }

  Future<List<Post>> getUserPosts(String username) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/user/posts/$username'));
      List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, String>?> uploadChatFile(File file) async {
    var req = http.MultipartRequest('POST', Uri.parse('$baseUrl/chat/upload'));
    req.files.add(await http.MultipartFile.fromPath('file', file.path));
    try {
      final res = await req.send();
      final respStr = await res.stream.bytesToString();
      final data = jsonDecode(respStr);
      return {"url": data['url'], "type": data['type']};
    } catch (e) {
      return null;
    }
  }
}
