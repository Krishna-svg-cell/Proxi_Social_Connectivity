import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import '../app_state.dart';

class StoryViewScreen extends StatefulWidget {
  final dynamic story;
  const StoryViewScreen({super.key, required this.story});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  double _progress = 0.0;
  Timer? _timer;
  bool _isPaused = false;
  final TextEditingController _replyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isPaused) {
        setState(() {
          _progress += 0.01;
          if (_progress >= 1.0) {
            _timer?.cancel();
            Navigator.pop(context);
          }
        });
      }
    });
  }

  void _sendReply() async {
    if (_replyCtrl.text.isEmpty) return;
    _timer?.cancel(); // Stop timer while sending
    
    final state = Provider.of<AppState>(context, listen: false);
    await state.api.sendDirectMessage(
      state.currentUser!.username, 
      widget.story['username'], 
      "Replied to story: ${_replyCtrl.text}"
    );
    
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reply sent!")));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPaused = true),
          onTapUp: (_) => setState(() => _isPaused = false),
          child: Stack(
            children: [
              // STORY CONTENT
              Center(
                child: widget.story['media_url'] != null
                ? CachedNetworkImage(
                    imageUrl: "${ApiService.baseUrl}${widget.story['media_url']}",
                    fit: BoxFit.contain,
                    errorWidget: (c,u,e) => const Text("Could not load image", style: TextStyle(color: Colors.white)),
                  )
                : Container(
                    color: Colors.blue, 
                    alignment: Alignment.center,
                    child: Text(widget.story['text'], style: const TextStyle(color: Colors.white, fontSize: 24))
                  ),
              ),
              
              // PROGRESS BAR
              Positioned(
                top: 10, left: 10, right: 10,
                child: LinearProgressIndicator(value: _progress, color: Colors.white, backgroundColor: Colors.white24),
              ),
              
              // USER INFO
              Positioned(
                top: 30, left: 15,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(widget.story['author_avatar'] ?? ""),
                      onBackgroundImageError: (_,__) {},
                    ),
                    const SizedBox(width: 10),
                    Text(widget.story['username'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              ),

              // REPLY FIELD
              Positioned(
                bottom: 10, left: 10, right: 10,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Send message...", 
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20)
                        ),
                        onTap: () => setState(() => _isPaused = true), // Pause when typing
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendReply,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}