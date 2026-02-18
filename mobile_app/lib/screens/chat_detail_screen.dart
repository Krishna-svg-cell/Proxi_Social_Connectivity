import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../app_state.dart';
import '../api_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String targetUser;
  const ChatDetailScreen({super.key, required this.targetUser});
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _text = TextEditingController();
  late WebSocketChannel _channel;
  List<dynamic> _msgs = [];

  @override
  void initState() {
    super.initState();
    final state = Provider.of<AppState>(context, listen: false);
    _channel = WebSocketChannel.connect(Uri.parse('${state.api.wsUrl}/ws/${state.currentUser!.username}'));
    _channel.stream.listen((data) { _fetchHistory(); });
    _fetchHistory();
  }
  
  void _fetchHistory() async {
    final state = Provider.of<AppState>(context, listen: false);
    final hist = await state.api.getChatHistory(state.currentUser!.username, widget.targetUser);
    if (mounted) setState(() => _msgs = hist);
  }

  void _send({String? text, String? fileUrl, String? fileType}) {
    if ((text == null || text.isEmpty) && fileUrl == null) return;
    
    final payload = {
      "to": widget.targetUser, 
      "text": text ?? "",
      "file_url": fileUrl,
      "file_type": fileType
    };
    
    _channel.sink.add(jsonEncode(payload));
    _text.clear();
    // Optimistic update
    setState(() {
      _msgs.add({...payload, "sender": "me"}); 
    });
  }

  void _pickFile() async {
    // Simple picker: Camera/Gallery for now. 
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      final state = Provider.of<AppState>(context, listen: false);
      final res = await state.api.uploadChatFile(File(x.path));
      if (res != null) {
        _send(fileUrl: res['url'], fileType: 'image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myName = Provider.of<AppState>(context).currentUser!.username;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.targetUser)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _msgs.length,
              itemBuilder: (ctx, i) {
                final m = _msgs[i];
                final isMe = m['sender'] == myName || m['sender'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (m['file_url'] != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: CachedNetworkImage(
                              imageUrl: "${ApiService.baseUrl}${m['file_url']}",
                              placeholder: (c,u) => const CircularProgressIndicator(),
                              errorWidget: (c,u,e) => const Icon(Icons.insert_drive_file),
                            ),
                          ),
                        if (m['text'] != null && m['text'].isNotEmpty)
                          Text(m['text'], style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.attach_file), onPressed: _pickFile),
              Expanded(child: TextField(controller: _text, decoration: const InputDecoration(hintText: "Type..."))),
              IconButton(icon: const Icon(Icons.send), onPressed: () => _send(text: _text.text))
            ]),
          )
        ],
      ),
    );
  }
}