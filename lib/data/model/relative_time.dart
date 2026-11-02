/// Formats a [DateTime] as "Today, 2:12 PM", "Yesterday, 8:05 AM" or
/// "3 days ago, 6:22 PM", matching the reference alert-history design.
String relativeTimeLabel(DateTime timestamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final that = DateTime(timestamp.year, timestamp.month, timestamp.day);
  final dayDiff = today.difference(that).inDays;

  final String dayLabel;
  if (dayDiff == 0) {
    dayLabel = 'Today';
  } else if (dayDiff == 1) {
    dayLabel = 'Yesterday';
  } else {
    dayLabel = '$dayDiff days ago';
  }

  return '$dayLabel, ${_formatClock(timestamp)}';
}

String _formatClock(DateTime t) {
  final hour24 = t.hour;
  final period = hour24 >= 12 ? 'PM' : 'AM';
  var hour12 = hour24 % 12;
  if (hour12 == 0) hour12 = 12;
  final minute = t.minute.toString().padLeft(2, '0');
  return '$hour12:$minute $period';
}
