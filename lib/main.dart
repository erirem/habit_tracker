import 'package:flutter/material.dart';
import 'models/habit.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Habit> _habits = [];
  int streak = 0;

  void _addHabit(String name, String description) {
    setState(() {
      _habits.add(Habit(name: name, description: description));
    });
  }

  void _markHabitCompleted(Habit habit) {
    setState(() {
      habit.lastCompletedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: Column(
        children: <Widget>[
          HabitInput(onAddHabit: _addHabit),
          Expanded(child: HabitList(habits: _habits, onMarkCompleted: _markHabitCompleted)),
          SizedBox(height: 20),
          StreakIndicator(streak: streak),  // Pass streak as parameter
        ],
      ),
    );
  }
}

class StreakIndicator extends StatelessWidget {
  final int streak;

  StreakIndicator({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Current Streak',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Background circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
            // Streak circle
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$streak',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Days in a row!',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class HabitInput extends StatefulWidget {
  final Function(String, String) onAddHabit;

  HabitInput({required this.onAddHabit});

  @override
  _HabitInputState createState() => _HabitInputState();
}

class _HabitInputState extends State<HabitInput> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submitData() {
    final name = _nameController.text;
    final description = _descriptionController.text;
    if (name.isNotEmpty && description.isNotEmpty) {
      widget.onAddHabit(name, description);
      _nameController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Habit Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Habit Description'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Add Habit'),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }
}

class HabitList extends StatelessWidget {
  final List<Habit> habits;
  final Function(Habit) onMarkCompleted;

  HabitList({required this.habits, required this.onMarkCompleted});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (ctx, index) {
        final habit = habits[index];
        final lastCompletedDate = habit.lastCompletedDate != null
            ? DateFormat('yyyy-MM-dd').format(habit.lastCompletedDate!)
            : 'Not completed';
        final streakDays = habit.getStreakDays();

        return ListTile(
          title: Text(habit.name),
          subtitle: Text('${habit.description}\nLast completed: $lastCompletedDate\nCurrent streak: $streakDays days'),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () => onMarkCompleted(habit),
          ),
        );
      },
    );
  }
}
