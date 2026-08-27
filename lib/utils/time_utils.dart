import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TimeUtils {
  /// Midnight at the start of [value]'s calendar day.
  static DateTime startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  /// [date] shifted by [amount] calendar days.
  ///
  /// Prefer this over `DateTime.add(Duration(days: n))`. That adds a fixed
  /// 24-hour span, which a daylight-saving transition knocks off the
  /// calendar: starting from midnight it arrives at 23:00 the day before,
  /// or 01:00 the day after. Day-keyed lookups, streaks and range queries
  /// then quietly miss.
  static DateTime addDays(DateTime date, int amount) =>
      DateTime(date.year, date.month, date.day + amount);

  /// Whole calendar days from [from] to [to], ignoring clock time.
  ///
  /// `DateTime.difference().inDays` is unsafe here for the same reason.
  /// Across the spring-forward switch two consecutive midnights are only 23
  /// hours apart, and truncating that gives 0 days where the calendar says
  /// 1. Rounding the hour count instead lands on the calendar answer at
  /// both transitions.
  static int daysBetween(DateTime from, DateTime to) =>
      (startOfDay(to).difference(startOfDay(from)).inHours / 24).round();

  /// Midnight on the Monday that starts [value]'s week.
  static DateTime startOfWeek(DateTime value) =>
      addDays(startOfDay(value), -(value.weekday - 1));

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
