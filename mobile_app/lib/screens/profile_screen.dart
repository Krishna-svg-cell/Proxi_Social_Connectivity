import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_state.dart';
import '../models.dart';
import '../api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Post> _myPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchMyPosts();
  }

  void _fetchMyPosts() async {
    final state = Provider.of<AppState>(context, listen: false);
    if (state.currentUser != null) {
      final posts = await state.api.getUserPosts(state.currentUser!.username);
      if(mounted) setState(() => _myPosts = posts);
    }
  }

  void _showEditBio() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("Update Bio"),
      content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: "Enter new bio")),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
        ElevatedButton(onPressed: () async {
          // Call API to update
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bio Updated!")));
        }, child: const Text("Save"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context); // Listen to changes
    final user = state.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.username ?? ""),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: (){
             showModalBottomSheet(context: context, builder: (ctx) => Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 ListTile(
                   leading: const Icon(Icons.edit), 
                   title: const Text("Edit Bio"),
                   onTap: () { Navigator.pop(ctx); _showEditBio(); },
                 ),
                 ListTile(
                   leading: const Icon(Icons.logout, color: Colors.red), 
                   title: const Text("Log Out", style: TextStyle(color: Colors.red)),
                   onTap: () { 
                     // Navigate back to auth
                     Navigator.of(context).popUntil((route) => route.isFirst);
                   },
                 ),
               ],
             ));
          })
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // AVATAR
          CircleAvatar(
            radius: 50, 
            // FIX: Use getAvatar
            backgroundImage: NetworkImage(user?.getAvatar(state.isFormal) ?? ""),
            onBackgroundImageError: (_,__) {},
          ),
          const SizedBox(height: 10),
          Text(user?.username ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Text(user?.bio ?? "No bio", style: const TextStyle(color: Colors.grey)),
          
          const SizedBox(height: 20),
          const Divider(),
          
          // REAL POSTS GRID
          Expanded(
            child: _myPosts.isEmpty 
            ? const Center(child: Text("No posts yet."))
            : GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: _myPosts.length, 
              itemBuilder: (ctx, i) {
                final p = _myPosts[i];
                if (p.mediaUrl == null) return Container(color: Colors.grey[300], child: const Icon(Icons.text_fields));
                return CachedNetworkImage(
                  imageUrl: "${ApiService.baseUrl}${p.mediaUrl}",
                  fit: BoxFit.cover,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}