import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TimeUtils {
  static String formatDuration(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatDurationReadable(int totalSeconds) {
    if (totalSeconds < 60) return '$totalSeconds s';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  static String formatTimeOfDay(
    DateTime dateTime, {
    String amLabel = 'AM',
    String pmLabel = 'PM',
  }) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour >= 12 ? pmLabel : amLabel;
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:${minute.toString().padLeft(2, '0')} $amPm';
  }

  static String formatDate(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}';
  }

  static String getTimeOfDayCategory(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return 'Night';
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 21) return 'Evening';
    return 'Night';
  }

  static List<Color> getGradientForTimeOfDay(
    DateTime time, {
    Brightness brightness = Brightness.light,
  }) {
    final hour = time.hour;
    final bool isDark = brightness == Brightness.dark;
    if (hour < 6) {
      return isDark ? AppColors.gradientNightDark : AppColors.gradientNight;
    }
    if (hour < 12) {
      return isDark ? AppColors.gradientSunriseDark : AppColors.gradientSunrise;
    }
    if (hour < 17) {
      return isDark ? AppColors.gradientOceanDark : AppColors.gradientOcean;
    }
    if (hour < 21) {
      return isDark ? AppColors.gradientSunsetDark : AppColors.gradientSunset;
    }
    return isDark ? AppColors.gradientNightDark : AppColors.gradientNight;
  }
}
