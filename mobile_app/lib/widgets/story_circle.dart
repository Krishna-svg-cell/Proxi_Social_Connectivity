import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api_service.dart';

class StoryCircle extends StatelessWidget {
  final dynamic story;
  const StoryCircle({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage("${ApiService.baseUrl}${story['media_url']}"),
            backgroundColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 4),
        Text(story['username'], style: const TextStyle(fontSize: 10))
      ]),
    );
  }
}