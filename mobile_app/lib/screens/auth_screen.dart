import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'home_shell.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final uCtrl = TextEditingController();
    final pCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Proxi", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.blue)),
            const Text("Dual Mode Social", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            TextField(controller: uCtrl, decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(controller: pCtrl, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () async {
                await Provider.of<AppState>(context, listen: false).login(uCtrl.text, pCtrl.text);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
              },
              child: const Text("Enter App"),
            )
          ],
        ),
      ),
    );
  }
}