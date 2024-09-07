import 'package:flutter/material.dart';

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
  final List<String> _habits = [];

  void _addHabit(String habit) {
    setState(() {
      _habits.add(habit);
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
          Expanded(child: HabitList(habits: _habits)),
        ],
      ),
    );
  }
}

class HabitInput extends StatefulWidget {
  final Function(String) onAddHabit;

  HabitInput({required this.onAddHabit});

  @override
  _HabitInputState createState() => _HabitInputState();
}

class _HabitInputState extends State<HabitInput> {
  final _controller = TextEditingController();

  void _submitData() {
    final habit = _controller.text;
    if (habit.isNotEmpty) {
      widget.onAddHabit(habit);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter a new habit'),
              onSubmitted: (_) => _submitData(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }
}

class HabitList extends StatelessWidget {
  final List<String> habits;

  HabitList({required this.habits});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(habits[index]),
        );
      },
    );
  }
}
