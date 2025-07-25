import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'meal_plan_screen.dart'; // Create this file next

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase failed to initialize: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Plan App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: WorkoutPlanUploadScreen(), // ✅ Now goes to meal plan screen
    );
  }
}
