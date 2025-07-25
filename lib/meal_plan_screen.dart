// // TODO Implement this library.
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MealPlanScreen extends StatelessWidget {
//   const MealPlanScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference mealPlans = FirebaseFirestore.instance.collection(
//       'mealPlans',
//     );

//     return Scaffold(
//       appBar: AppBar(title: const Text('Weekly Meal Plans')),
//       body: FutureBuilder<QuerySnapshot>(
//         future: mealPlans.get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return const Center(child: CircularProgressIndicator());

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
//             return const Center(child: Text('No meal plans found.'));

//           final docs = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(data['day'] ?? 'Unknown Day'),
//                   subtitle: Text(
//                     '🍳 Breakfast: ${data['breakfast'] ?? 'N/A'}\n'
//                     '🥗 Lunch: ${data['lunch'] ?? 'N/A'}\n'
//                     '🍽️ Dinner: ${data['dinner'] ?? 'N/A'}',
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MealPlanScreen extends StatefulWidget {
//   const MealPlanScreen({super.key});

//   @override
//   State<MealPlanScreen> createState() => _MealPlanScreenState();
// }

// class _MealPlanScreenState extends State<MealPlanScreen>
//     with SingleTickerProviderStateMixin {
//   String selectedDiet = 'Vegetarian';
//   String selectedGoal = 'Weight Loss';
//   late TabController _tabController;

//   Map<String, dynamic> fetchedMealPlan = {};
//   bool isLoading = true;

//   final List<String> days = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: days.length, vsync: this);
//     fetchMealPlansFromFirebase();
//   }

//   Future<void> fetchMealPlansFromFirebase() async {
//     try {
//       final collection = FirebaseFirestore.instance.collection('meal_plans');
//       final docs = await collection.get();

//       Map<String, dynamic> finalPlan = {};

//       for (var doc in docs.docs) {
//         final id = doc.id.replaceAll('_', ' ');
//         final parts = id.split(' ');
//         final diet = parts[0]; // Vegetarian or Non-Vegetarian
//         final goal = parts.sublist(1).join(' '); // Weight Loss, etc.

//         finalPlan[diet] ??= {};
//         finalPlan[diet][goal] = doc.data(); // day-wise list
//       }

//       setState(() {
//         fetchedMealPlan = finalPlan;
//         isLoading = false;
//       });

//       debugPrint('✅ Meal plans fetched successfully.');
//     } catch (e) {
//       debugPrint('❌ Error fetching meal plans: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final meals = fetchedMealPlan[selectedDiet]?[selectedGoal] ?? {};

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'Weekly Meal Plans',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green[700],
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: DropdownButton<String>(
//                           value: selectedDiet,
//                           isExpanded: true,
//                           items: ['Vegetarian', 'Non-Vegetarian']
//                               .map(
//                                 (e) =>
//                                     DropdownMenuItem(value: e, child: Text(e)),
//                               )
//                               .toList(),
//                           onChanged: (val) {
//                             setState(() => selectedDiet = val!);
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: DropdownButton<String>(
//                           value: selectedGoal,
//                           isExpanded: true,
//                           items: ['Weight Loss', 'Muscle Gain', 'Maintenance']
//                               .map(
//                                 (e) =>
//                                     DropdownMenuItem(value: e, child: Text(e)),
//                               )
//                               .toList(),
//                           onChanged: (val) {
//                             setState(() => selectedGoal = val!);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TabBar(
//                   controller: _tabController,
//                   isScrollable: true,
//                   labelColor: Colors.black,
//                   indicatorColor: Colors.green,
//                   tabs: days.map((day) => Tab(text: day)).toList(),
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: days.map((day) {
//                       final mealsForDay = meals[day] as List<dynamic>? ?? [];

//                       return mealsForDay.isEmpty
//                           ? const Center(child: Text('No meals available.'))
//                           : ListView.builder(
//                               itemCount: mealsForDay.length,
//                               itemBuilder: (context, index) {
//                                 final meal = mealsForDay[index];
//                                 return Card(
//                                   margin: const EdgeInsets.all(12),
//                                   elevation: 4,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: ListTile(
//                                     leading: Text(
//                                       meal['icon'] ?? '🍽️',
//                                       style: const TextStyle(fontSize: 30),
//                                     ),
//                                     title: Text(
//                                       meal['name'] ?? '',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     subtitle: Text(meal['time'] ?? ''),
//                                   ),
//                                 );
//                               },
//                             );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlanUploadScreen extends StatelessWidget {
  WorkoutPlanUploadScreen({super.key});

  final Map<String, List<List<List<String>>>> workoutPlans = {
    // 🔽 Paste your full BEGINNER, INTERMEDIATE, ADVANCED workoutPlans here
    "BEGINNER": [
      [
        // Week 1
        [
          "Jumping Jacks (2x10)",
          "Bodyweight Squats (2x10)",
          "Wall Sit (20 sec)",
          "Push-ups (Knee, 2x8)",
          "Crunches (2x15)",
          "Plank (20 sec)",
          "Lunges (2x8 each leg)",
        ],
        [
          "High Knees (30 sec)",
          "Chair Squats (2x10)",
          "Incline Push-ups (2x8)",
          "Superman Hold (20 sec)",
          "Leg Raises (2x12)",
          "Russian Twists (2x15)",
          "Side Lunges (2x10)",
        ],
        [
          "Butt Kicks (30 sec)",
          "Squats (2x12)",
          "Push-ups (2x10)",
          "Bicycle Crunches (2x20)",
          "Bird Dog (2x10)",
          "Hip Bridge (2x12)",
          "Side Plank (20 sec)",
        ],
        [
          "Mountain Climbers (30 sec)",
          "Wall Sit (30 sec)",
          "Push-ups (2x12)",
          "Reverse Crunch (2x15)",
          "Side Kicks (2x10)",
          "Glute Bridge (2x15)",
          "Arm Circles (30 sec)",
        ],
        [
          "Step-ups (2x10)",
          "Leg Raises (2x15)",
          "Superman (20 sec)",
          "Russian Twists (2x20)",
          "Heel Touches (2x20)",
          "Plank (30 sec)",
          "Knee Push-ups (2x10)",
        ],
        [
          "High Knees (30 sec)",
          "Chair Squats (2x12)",
          "Side Leg Raises (2x15)",
          "Bird Dog (2x12)",
          "Crunches (2x20)",
          "Wall Sit (30 sec)",
          "Arm Circles (30 sec)",
        ],
        [
          "Jumping Jacks (2x15)",
          "Push-ups (2x12)",
          "Hip Bridge (2x15)",
          "Side Lunges (2x12)",
          "Plank (30 sec)",
          "Arm Circles (30 sec)",
        ],
      ],
      [
        // Week 2
        [
          "Jump Rope (30 sec)",
          "Squats (3x10)",
          "Incline Push-ups (3x10)",
          "Leg Raises (2x15)",
          "Superman Hold (30 sec)",
          "Plank (30 sec)",
          "Wall Sit (30 sec)",
        ],
        [
          "High Knees (30 sec)",
          "Chair Squats (3x12)",
          "Push-ups (3x10)",
          "Crunches (2x20)",
          "Bird Dog (2x12)",
          "Glute Bridge (2x15)",
          "Side Kicks (2x10)",
        ],
        [
          "Step-ups (2x12)",
          "Side Plank (30 sec)",
          "Heel Touches (2x20)",
          "Squats (3x12)",
          "Mountain Climbers (30 sec)",
          "Push-ups (3x12)",
          "Plank (30 sec)",
        ],
        [
          "Jumping Jacks (3x15)",
          "Crunches (3x20)",
          "Lunges (3x10 each leg)",
          "Wall Sit (45 sec)",
          "Superman (30 sec)",
          "Arm Circles (30 sec)",
        ],
        [
          "Leg Raises (3x15)",
          "Chair Squats (3x15)",
          "Incline Push-ups (3x12)",
          "Russian Twists (3x20)",
          "Bird Dog (3x12)",
          "Plank (30 sec)",
        ],
        [
          "Butt Kicks (30 sec)",
          "Push-ups (3x12)",
          "Squats (3x15)",
          "Side Lunges (3x12)",
          "Side Plank (30 sec)",
          "Knee Taps (3x15)",
          "Wall Sit (45 sec)",
        ],
        [
          "High Knees (45 sec)",
          "Crunches (3x20)",
          "Jump Rope (45 sec)",
          "Superman (30 sec)",
          "Leg Raises (3x20)",
          "Plank (30 sec)",
        ],
      ],
      [
        // Week 3
        [
          "Jumping Jacks (3x20)",
          "Wall Sit (1 min)",
          "Push-ups (3x15)",
          "Leg Raises (3x20)",
          "Side Plank (30 sec)",
          "Squats (3x15)",
          "Superman Hold (45 sec)",
        ],
        [
          "Mountain Climbers (45 sec)",
          "Chair Squats (3x15)",
          "Russian Twists (3x25)",
          "Push-ups (3x15)",
          "Bird Dog (3x15)",
          "Heel Touches (3x20)",
        ],
        [
          "Step-ups (3x15)",
          "Jump Rope (1 min)",
          "Plank (45 sec)",
          "Incline Push-ups (3x15)",
          "Crunches (3x25)",
          "Squats (3x20)",
        ],
        [
          "High Knees (45 sec)",
          "Side Lunges (3x15)",
          "Push-ups (3x15)",
          "Leg Raises (3x20)",
          "Wall Sit (1 min)",
          "Superman Pull (3x15)",
        ],
        [
          "Burpees (2x8)",
          "Chair Squats (3x15)",
          "Bird Dog (3x15)",
          "Plank (45 sec)",
          "Jumping Jacks (3x20)",
          "Push-ups (3x15)",
        ],
        [
          "Step-ups (3x15)",
          "Crunches (3x30)",
          "Glute Bridge (3x20)",
          "Wall Sit (45 sec)",
          "Side Leg Raises (3x15)",
          "Arm Circles (45 sec)",
        ],
        [
          "Mountain Climbers (1 min)",
          "Push-ups (3x15)",
          "Wall Sit (1 min)",
          "Bicycle Crunches (3x25)",
          "Plank (45 sec)",
          "Superman (45 sec)",
        ],
      ],
      [
        // Week 4
        [
          "Jump Rope (1 min)",
          "Squats (3x20)",
          "Push-ups (3x20)",
          "Leg Raises (3x20)",
          "Russian Twists (3x30)",
          "Wall Sit (1 min)",
          "Plank (1 min)",
        ],
        [
          "High Knees (1 min)",
          "Side Lunges (3x20)",
          "Chair Squats (3x20)",
          "Crunches (3x30)",
          "Push-ups (3x20)",
          "Plank (1 min)",
        ],
        [
          "Burpees (2x10)",
          "Glute Bridge (3x20)",
          "Bird Dog (3x15)",
          "Superman Hold (1 min)",
          "Plank Jacks (45 sec)",
          "Wall Sit (1 min)",
        ],
        [
          "Jumping Jacks (3x25)",
          "Lunges (3x15)",
          "Push-ups (3x20)",
          "Crunches (3x30)",
          "Side Plank (45 sec)",
          "Mountain Climbers (1 min)",
        ],
        [
          "Step-ups (3x20)",
          "Wall Sit (1 min)",
          "Incline Push-ups (3x20)",
          "Leg Raises (3x25)",
          "Russian Twists (3x30)",
          "Plank (1 min)",
        ],
        [
          "Jump Rope (1 min)",
          "Side Kicks (3x15)",
          "Chair Squats (3x20)",
          "Push-ups (3x20)",
          "Heel Touches (3x30)",
          "Superman Hold (1 min)",
        ],
        [
          "Burpees (2x12)",
          "Mountain Climbers (1 min)",
          "Squats (3x25)",
          "Push-ups (3x20)",
          "Plank (1 min)",
          "Glute Bridge (3x20)",
          "Arm Circles (1 min)",
        ],
      ],
    ],
    "INTERMEDIATE": [
      [
        // Week 1
        [
          "Burpees (3x10)",
          "Jump Squats (3x10)",
          "Standard Push-ups (3x12)",
          "V-ups (3x15)",
          "Superman Pull (3x10)",
          "Plank Shoulder Tap (30 sec)",
          "Lunges with Twist (3x10)",
        ],
        [
          "Skaters (30 sec)",
          "Jumping Lunges (3x10)",
          "Wide Arm Push-ups (3x12)",
          "Leg Raise & Hold (30 sec)",
          "Plank Jacks (30 sec)",
          "Mountain Climbers (30 sec)",
          "Spiderman Plank (30 sec)",
        ],
        [
          "Tuck Jumps (3x10)",
          "Step-ups (3x10)",
          "Incline Push-ups (3x12)",
          "Russian Twists (3x15)",
          "Single-Leg Glute Bridge (3x10)",
          "Bicycle Crunches (3x20)",
          "Side Plank Raises (3x12)",
        ],
        [
          "Jump Rope (1 min)",
          "Squat Pulses (3x15)",
          "Push-up to T (3x10)",
          "Heel Touches (3x20)",
          "Bird Dogs (3x12)",
          "Lunge to Knee Raise (3x10)",
          "Superman (30 sec)",
        ],
        [
          "Plank to Push-up (3x10)",
          "Wall Sit (1 min)",
          "Jump Squats (3x15)",
          "Push-ups (3x15)",
          "V-Ups (3x20)",
          "Mountain Climbers (45 sec)",
          "Russian Twists (3x25)",
        ],
        [
          "Skaters (45 sec)",
          "Step-ups (3x12)",
          "Incline Push-ups (3x15)",
          "Plank Jacks (45 sec)",
          "Crunches (3x25)",
          "Bird Dog (3x15)",
          "Side Plank (45 sec)",
        ],
        [
          "Jump Rope (1 min)",
          "Squats (3x20)",
          "Standard Push-ups (3x15)",
          "Plank Hold (1 min)",
          "Glute Bridge (3x20)",
          "Side Kicks (3x15)",
          "Bicycle Crunches (3x25)",
        ],
      ],
      [
        // Week 2
        [
          "Burpees (3x12)",
          "Lunges (3x15)",
          "Push-ups (3x15)",
          "Leg Raises (3x20)",
          "Superman Pull (3x15)",
          "Plank Shoulder Taps (45 sec)",
          "Side Plank Raises (3x12)",
        ],
        [
          "Jump Lunges (3x15)",
          "Wall Sit (1 min)",
          "Wide Arm Push-ups (3x15)",
          "Russian Twists (3x25)",
          "Mountain Climbers (1 min)",
          "Bird Dog (3x15)",
          "Plank (1 min)",
        ],
        [
          "Jump Squats (3x15)",
          "Incline Push-ups (3x15)",
          "Heel Touches (3x25)",
          "Bicycle Crunches (3x30)",
          "Side Leg Raises (3x15)",
          "Lunge to Knee Raise (3x12)",
          "Superman (45 sec)",
        ],
        [
          "Skaters (1 min)",
          "Step-ups (3x15)",
          "Plank Jacks (1 min)",
          "Push-up to T (3x15)",
          "Glute Bridge (3x20)",
          "Crunches (3x30)",
          "Plank (1 min)",
        ],
        [
          "Tuck Jumps (3x12)",
          "Wall Sit (1 min)",
          "Push-ups (3x20)",
          "Leg Raises (3x25)",
          "Bird Dog (3x15)",
          "Side Plank (1 min)",
          "Jump Rope (1 min)",
        ],
        [
          "Mountain Climbers (1 min)",
          "Jump Squats (3x20)",
          "Incline Push-ups (3x20)",
          "Russian Twists (3x30)",
          "Heel Touches (3x30)",
          "Plank to Push-up (3x15)",
          "Superman Hold (45 sec)",
        ],
        [
          "Jump Rope (1 min)",
          "Squats (3x25)",
          "Push-ups (3x20)",
          "Plank (1 min)",
          "Side Plank Dips (3x15)",
          "Crunches (3x30)",
          "Step-ups (3x15)",
        ],
      ],
      [
        // Week 3
        [
          "Burpee to Tuck Jump (3x10)",
          "Jump Lunges (3x15)",
          "Push-ups (3x20)",
          "L-Sit Hold (30 sec)",
          "Russian Twists (3x30)",
          "Mountain Climbers (1 min)",
          "Side Plank (1 min)",
        ],
        [
          "Skaters (1 min)",
          "Wall Sit (1 min)",
          "Wide Arm Push-ups (3x20)",
          "Plank Shoulder Taps (1 min)",
          "Step-ups (3x20)",
          "Crunches (3x35)",
          "Bird Dog (3x20)",
        ],
        [
          "Jump Squats (3x20)",
          "Push-up to T (3x15)",
          "Side Kicks (3x20)",
          "Russian Twists (3x30)",
          "Glute Bridge (3x25)",
          "Plank (1 min)",
          "Superman Hold (1 min)",
        ],
        [
          "Tuck Jumps (3x12)",
          "Jump Rope (1 min)",
          "Incline Push-ups (3x20)",
          "Heel Touches (3x35)",
          "Bicycle Crunches (3x35)",
          "Side Plank Dips (3x20)",
          "Wall Sit (1 min)",
        ],
        [
          "Plank Jacks (1 min)",
          "Chair Squats (3x25)",
          "Push-ups (3x20)",
          "Bird Dog (3x20)",
          "Lunges with Twist (3x20)",
          "Plank (1 min)",
          "Mountain Climbers (1 min)",
        ],
        [
          "Burpees (3x15)",
          "Jumping Lunges (3x20)",
          "Push-ups (3x25)",
          "Crunches (3x40)",
          "Side Leg Raises (3x20)",
          "Plank to Push-up (3x20)",
          "Jump Rope (1 min)",
        ],
        [
          "Jump Squats (3x25)",
          "Wall Sit (1 min)",
          "Side Plank (1 min)",
          "Superman Pull (3x20)",
          "Russian Twists (3x35)",
          "Push-ups (3x25)",
          "Plank Jacks (1 min)",
        ],
      ],
      [
        // Week 4
        [
          "Burpee to Jump Squat (3x12)",
          "Tuck Jumps (3x15)",
          "Push-up to T (3x20)",
          "L-Sit Hold (45 sec)",
          "Plank (1 min)",
          "Side Plank Dips (3x20)",
          "Crunches (3x40)",
        ],
        [
          "Jump Lunges (3x20)",
          "Wall Sit (1 min)",
          "Incline Push-ups (3x20)",
          "Bird Dog (3x20)",
          "Heel Touches (3x35)",
          "Mountain Climbers (1 min)",
          "Side Kicks (3x20)",
        ],
        [
          "Jump Rope (1.5 min)",
          "Squats (3x30)",
          "Push-ups (3x25)",
          "Russian Twists (3x40)",
          "Plank Shoulder Taps (1 min)",
          "Step-ups (3x20)",
          "Superman Hold (1 min)",
        ],
        [
          "Tuck Jumps (3x15)",
          "Chair Squats (3x30)",
          "Wide Arm Push-ups (3x25)",
          "Crunches (3x40)",
          "Side Leg Raises (3x25)",
          "Plank (1 min)",
          "Wall Sit (1 min)",
        ],
        [
          "Burpees (3x15)",
          "Jumping Lunges (3x25)",
          "Push-ups (3x30)",
          "Bird Dog (3x25)",
          "Side Plank (1 min)",
          "Heel Touches (3x40)",
          "Jump Rope (1.5 min)",
        ],
        [
          "Mountain Climbers (1.5 min)",
          "Step-ups (3x25)",
          "Push-up to T (3x25)",
          "Leg Raises (3x30)",
          "Plank Jacks (1.5 min)",
          "Superman Hold (1 min)",
          "Crunches (3x45)",
        ],
        [
          "Jump Rope (2 min)",
          "Squats (3x35)",
          "Push-ups (3x30)",
          "Lunge to Knee Raise (3x25)",
          "Plank (1 min)",
          "Bird Dog (3x25)",
          "Russian Twists (3x45)",
        ],
      ],
    ],
    "ADVANCED": [
      [
        // Week 1
        [
          "Clapping Push-ups (3x10)",
          "Jump Squats (3x15)",
          "Burpee to Pull-up (3x10)",
          "Hollow Hold (45 sec)",
          "One-leg Glute Bridge (3x12)",
          "Plank to Push-up (3x12)",
          "Mountain Climbers (1 min)",
        ],
        [
          "Jump Lunges (3x15)",
          "Diamond Push-ups (3x12)",
          "Pistol Squats (3x6 each leg)",
          "L-sit Hold (30 sec)",
          "Dragon Flag (3x8)",
          "Handstand Hold (30 sec)",
          "Superman Hold (45 sec)",
        ],
        [
          "Squat Jumps (3x15)",
          "Archer Push-ups (3x10)",
          "Plank with Reach (30 sec)",
          "Side Plank Dips (3x12)",
          "Elevated Pike Push-ups (3x10)",
          "One-arm Plank (30 sec)",
          "Single Leg Wall Sit (30 sec)",
        ],
        [
          "Burpee to Tuck Jump (3x10)",
          "One-arm Push-ups (assisted, 3x8)",
          "Box Jumps (3x12)",
          "Hanging Leg Raises (3x12)",
          "Side Plank with Twist (3x10)",
          "Wall Walk (3 reps)",
          "Superman Swims (30 sec)",
        ],
        [
          "Jump Rope (2 min)",
          "Jump Squats (3x20)",
          "Push-up to T (3x15)",
          "Hollow Body Rock (30 sec)",
          "Pistol Squats (3x8)",
          "Plank Jacks (1 min)",
          "L-Sit (30 sec)",
        ],
        [
          "Burpees (3x20)",
          "Clapping Push-ups (3x12)",
          "Step-ups with Knee Raise (3x15)",
          "Flutter Kicks (1 min)",
          "Superman Hold (1 min)",
          "Wall Sit (1.5 min)",
          "Tuck Jumps (3x12)",
        ],
        [
          "Mountain Climbers (1.5 min)",
          "Incline Push-ups (3x20)",
          "Jump Lunges (3x20)",
          "Leg Raises (3x25)",
          "Lunge to Twist (3x15)",
          "Plank to Push-up (3x20)",
        ],
      ],
      [
        // Week 2
        [
          "One-arm Push-ups (3x8)",
          "Box Jumps (3x15)",
          "Plank to Elbow Tap (1 min)",
          "Jump Squats (3x20)",
          "Flutter Kicks (1.5 min)",
          "L-Sit (30 sec)",
          "Wall Sit (1.5 min)",
        ],
        [
          "Burpee to Pull-up (3x12)",
          "Tuck Jumps (3x15)",
          "Push-up to T (3x20)",
          "Hollow Hold (45 sec)",
          "Dragon Flag (3x10)",
          "Jump Rope (2 min)",
          "Plank Shoulder Taps (1 min)",
        ],
        [
          "Jump Lunges (3x20)",
          "Diamond Push-ups (3x20)",
          "Plank Jacks (1.5 min)",
          "L-Sit (45 sec)",
          "Side Plank Twist (3x15)",
          "Clapping Push-ups (3x15)",
          "Wall Sit (2 min)",
        ],
        [
          "Jump Rope (2 min)",
          "Jump Squats (3x25)",
          "Push-ups (3x30)",
          "Leg Raise Hold (45 sec)",
          "Side Plank Dips (3x20)",
          "One-arm Plank (1 min)",
          "Mountain Climbers (2 min)",
        ],
        [
          "Burpees (3x25)",
          "Pistol Squats (3x10 each leg)",
          "Elevated Pike Push-ups (3x12)",
          "Wall Walk (3 reps)",
          "Plank to Push-up (3x20)",
          "Superman Swims (1 min)",
          "Crunches (3x50)",
        ],
        [
          "Step-ups with Dumbbell (3x15)",
          "Incline Push-ups (3x25)",
          "Tuck Jumps (3x15)",
          "Plank Jacks (2 min)",
          "Dragon Flag (3x12)",
          "Side Plank Dips (1 min)",
        ],
        [
          "Jump Rope (2 min)",
          "Jump Squats (3x30)",
          "Push-up to T (3x25)",
          "Bicycle Crunches (3x40)",
          "Wall Sit (2 min)",
          "L-Sit (1 min)",
          "Superman Hold (1 min)",
        ],
      ],
      [
        // Week 3
        [
          "Burpee to Tuck Jump (3x15)",
          "Box Jumps (3x20)",
          "Push-ups (3x30)",
          "Leg Raise (3x30)",
          "Wall Sit (2 min)",
          "Superman Pull (3x25)",
          "Mountain Climbers (2 min)",
        ],
        [
          "Jump Lunges (3x25)",
          "Incline Push-ups (3x25)",
          "Plank Shoulder Taps (1 min)",
          "Side Plank with Twist (3x20)",
          "L-Sit Hold (1 min)",
          "Flutter Kicks (2 min)",
        ],
        [
          "Clapping Push-ups (3x20)",
          "Jump Squats (3x30)",
          "Russian Twists (3x40)",
          "Dragon Flag (3x15)",
          "Superman Swims (1 min)",
          "Wall Walk (3 reps)",
        ],
        [
          "Pistol Squats (3x10 each leg)",
          "Push-up to T (3x30)",
          "Jump Rope (2.5 min)",
          "Side Kicks (3x20)",
          "Leg Raise Hold (1 min)",
          "Crunches (3x60)",
        ],
        [
          "One-arm Push-ups (assisted, 3x10)",
          "Step-ups (3x20)",
          "Elevated Pike Push-ups (3x15)",
          "Mountain Climbers (2.5 min)",
          "Plank to Push-up (3x25)",
          "L-Sit (1 min)",
        ],
        [
          "Jump Rope (2.5 min)",
          "Push-ups (3x30)",
          "Wall Sit (2.5 min)",
          "Flutter Kicks (2 min)",
          "Side Plank (1 min each)",
          "Superman Hold (1.5 min)",
        ],
        [
          "Burpees (3x30)",
          "Pistol Squats (3x12)",
          "Push-up to T (3x30)",
          "Plank Jacks (2 min)",
          "Leg Raises (3x35)",
          "L-Sit Hold (1 min)",
        ],
      ],
      [
        // Week 4
        [
          "Box Jumps (3x25)",
          "One-arm Push-ups (3x12)",
          "Burpees (3x30)",
          "Side Plank Dips (1 min)",
          "Superman Pull (3x25)",
          "Wall Walk (3x)",
        ],
        [
          "Jump Rope (3 min)",
          "Push-up to T (3x35)",
          "Tuck Jumps (3x20)",
          "Dragon Flag (3x20)",
          "Wall Sit (3 min)",
          "L-Sit (1 min)",
          "Crunches (3x60)",
        ],
        [
          "Clapping Push-ups (3x25)",
          "Jump Squats (3x35)",
          "Bicycle Crunches (3x50)",
          "Flutter Kicks (2.5 min)",
          "Mountain Climbers (3 min)",
          "Side Plank with Twist (1.5 min)",
        ],
        [
          "Pistol Squats (3x12 each)",
          "Incline Push-ups (3x30)",
          "Wall Walk (4 reps)",
          "Plank Jacks (2.5 min)",
          "Superman Swims (1.5 min)",
          "Push-up to T (3x30)",
        ],
        [
          "Jump Rope (3 min)",
          "Jump Lunges (3x30)",
          "Wall Sit (3 min)",
          "Russian Twists (3x50)",
          "Dragon Flag (3x20)",
          "Plank (2 min)",
        ],
        [
          "Burpee to Pull-up (3x20)",
          "Box Jumps (3x30)",
          "Elevated Pike Push-ups (3x20)",
          "Leg Raises (3x40)",
          "Flutter Kicks (2.5 min)",
          "L-Sit Hold (1 min)",
        ],
        [
          "Clapping Push-ups (3x30)",
          "Step-ups (3x25)",
          "Push-up to T (3x30)",
          "Mountain Climbers (3 min)",
          "Side Plank Dips (1 min)",
          "Wall Walk (3 reps)",
          "Crunches (3x60)",
        ],
      ],
    ],
  };

  Future<void> uploadWorkoutPlansToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (final level in workoutPlans.keys) {
      final weeks = workoutPlans[level]!;

      final Map<String, dynamic> formattedWeeks = {};

      for (int weekIndex = 0; weekIndex < weeks.length; weekIndex++) {
        final days = weeks[weekIndex];
        final Map<String, dynamic> formattedDays = {};

        for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
          formattedDays['Day ${dayIndex + 1}'] = days[dayIndex];
        }

        formattedWeeks['Week ${weekIndex + 1}'] = formattedDays;
      }

      final docRef = firestore
          .collection('workout_plans')
          .doc(level.toUpperCase());
      batch.set(docRef, formattedWeeks);
    }

    await batch.commit();
    debugPrint('✅ Workout plans uploaded successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Workout Plans")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await uploadWorkoutPlansToFirestore();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Workout plans uploaded')),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('❌ Upload failed: $e')));
            }
          },
          child: const Text("Upload Workout Plans to Firebase"),
        ),
      ),
    );
  }
}
