import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inHours < 1) {
        return '${difference.inMinutes} minutes ago';
      }
      else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      }
      else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }
      else {
        return DateFormat('dd MMM yyyy, HH:mm', 'en_US').format(dateTime);
      }
    } catch (e) {
      return isoDate;
    }
  }
  
  static String formatFullDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('EEEE, dd MMMM yyyy', 'en_US').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }
}
