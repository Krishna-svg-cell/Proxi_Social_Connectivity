import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_state.dart';
import 'chat_detail_screen.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});
  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool _isScanning = false;

  void _handleScan() async {
    setState(() => _isScanning = true);
    final state = Provider.of<AppState>(context, listen: false);
    state.scanNearby(); // Triggers the logic
    
    // Fake the "Real-time" visual for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if(mounted) setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    
    return Column(
      children: [
        // SCANNER AREA
        GestureDetector(
          onTap: _isScanning ? null : _handleScan,
          child: Container(
            height: 200, 
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // RIPPLES
                if (_isScanning) ...[
                  _ripple(100, 0),
                  _ripple(150, 400),
                  _ripple(200, 800),
                ],
                // MAIN BUTTON
                CircleAvatar(
                  radius: 40,
                  backgroundColor: _isScanning ? Colors.blue : Colors.grey[200],
                  child: Icon(LucideIcons.radar, color: _isScanning ? Colors.white : Colors.black, size: 30),
                ),
                if (_isScanning)
                  const Positioned(bottom: 0, child: Text("Scanning...", style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
          ),
        ),

        const Divider(),

        // RESULTS LIST
        Expanded(
          child: state.nearbyUsers.isEmpty 
          ? const Center(child: Text("Tap radar to scan for people.")) 
          : ListView.builder(
            itemCount: state.nearbyUsers.length,
            itemBuilder: (ctx, i) {
              final user = state.nearbyUsers[i];
              return ListTile(
                // FIX: Use getAvatar to choose the right one based on mode
                leading: CircleAvatar(backgroundImage: NetworkImage(user.getAvatar(state.isFormal))),
                title: Text(user.username),
                subtitle: Text(user.bio),
                trailing: IconButton(
                  icon: const Icon(LucideIcons.messageCircle, color: Colors.blue),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(targetUser: user.username))),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _ripple(double size, int delay) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2)),
    ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.5.seconds, delay: delay.ms).fadeOut(duration: 1.5.seconds, delay: delay.ms);
  }
}