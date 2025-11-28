import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Temporary script to clear all SharedPreferences data
/// Run with: flutter run -t lib/clear_storage_main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  print('✅ All SharedPreferences data has been cleared!');
  print('You can now close this app and run the main app again.');
  
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Storage Cleared!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('You can now close this app.'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  print('✅ Cleared again!');
                },
                child: const Text('Clear Again'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
