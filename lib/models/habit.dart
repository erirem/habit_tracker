import 'package:intl/intl.dart';

class Habit {
  final String name;
  final String description;
  DateTime? lastCompletedDate;

  Habit({required this.name, required this.description});

  int getStreakDays() {
    if (lastCompletedDate == null) {
      return 0;
    }
    final today = DateTime.now();
    final difference = today.difference(lastCompletedDate!).inDays;
    return difference;
  }
}
