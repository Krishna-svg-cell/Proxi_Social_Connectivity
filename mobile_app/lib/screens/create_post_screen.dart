import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _text = TextEditingController();
  File? _file;
  bool isStory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
        actions: [
          TextButton(onPressed: (){
            Provider.of<AppState>(context, listen: false).createPost(_text.text, _file, isStory);
            Navigator.pop(context);
          }, child: const Text("Share", style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              ChoiceChip(label: const Text("Feed Post"), selected: !isStory, onSelected: (v)=>setState(()=>isStory=false)),
              const SizedBox(width: 10),
              ChoiceChip(label: const Text("Story"), selected: isStory, onSelected: (v)=>setState(()=>isStory=true)),
            ]),
            const SizedBox(height: 20),
            TextField(
              controller: _text, 
              decoration: const InputDecoration(hintText: "What's happening?", border: InputBorder.none), 
              maxLines: 5
            ),
            if (_file != null) 
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_file!, height: 200, fit: BoxFit.cover)),
            const Spacer(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.image), 
                  label: const Text("Photo"),
                  onPressed: () async {
                     final x = await ImagePicker().pickImage(source: ImageSource.gallery);
                     if (x!=null) setState(()=>_file=File(x.path));
                  }
                ),
                TextButton.icon(
                  icon: const Icon(Icons.camera_alt), 
                  label: const Text("Camera"),
                  onPressed: () async {
                     final x = await ImagePicker().pickImage(source: ImageSource.camera);
                     if (x!=null) setState(()=>_file=File(x.path));
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}