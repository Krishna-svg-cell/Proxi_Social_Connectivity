import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../app_state.dart';
import '../constants.dart';
import 'feed_screen.dart';
import 'nearby_screen.dart';
import 'create_post_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart'; 

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _idx = 0;
  final _tabs = [
    const FeedScreen(),
    const NearbyScreen(),
    const SizedBox(), // Placeholder for Post button logic
    const ChatListScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final color = state.isFormal ? AppColors.formalPrimary : AppColors.casualPrimary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: state.isFormal ? AppColors.formalBg : null,
          gradient: state.isFormal ? null : const LinearGradient(colors: [AppColors.casualStart, AppColors.casualEnd])
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LOGO AREA
                    Row(children: [
                      Icon(LucideIcons.radio, color: color),
                      const SizedBox(width: 8),
                      Text("Proxi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
                    ]),
                    
                    // NOTIFICATION BUTTON
                    IconButton(
                      icon: const Icon(LucideIcons.bell), 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))
                    ),
                  ],
                ),
              ),
              
              // CONTENT AREA
              Expanded(child: _idx == 2 ? const SizedBox() : _tabs[_idx]),
              
              // BOTTOM NAVIGATION
              NavigationBar(
                selectedIndex: _idx,
                onDestinationSelected: (i) {
                  if (i == 2) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostScreen()));
                  } else {
                    setState(() => _idx = i);
                  }
                },
                destinations: const [
                  NavigationDestination(icon: Icon(LucideIcons.home), label: "Home"),
                  NavigationDestination(icon: Icon(LucideIcons.radar), label: "Nearby"),
                  NavigationDestination(icon: Icon(LucideIcons.plusSquare), label: "Post"),
                  NavigationDestination(icon: Icon(LucideIcons.messageCircle), label: "Chat"),
                  NavigationDestination(icon: Icon(LucideIcons.user), label: "Profile"),
                ],
              )
            ],
          ),
        ),
      ),

      // SINGLE CIRCLE BUTTON FOR MODE SWITCHING (Corner Button)
      floatingActionButton: _idx != 2 ? FloatingActionButton(
        onPressed: state.toggleMode,
        backgroundColor: state.isFormal ? AppColors.formalPrimary : AppColors.casualPrimary,
        child: const Icon(Icons.swap_horiz, color: Colors.white),
      ) : null,
    );
  }
}