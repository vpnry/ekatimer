enum TimerMode {
  timed,
  endAt,
  unlimited;

  String get label {
    switch (this) {
      case TimerMode.timed:
        return 'Timed';
      case TimerMode.endAt:
        return 'End At';
      case TimerMode.unlimited:
        return 'Unlimited';
    }
  }

  String get description {
    switch (this) {
      case TimerMode.timed:
        return 'Meditate for a set duration';
      case TimerMode.endAt:
        return 'Meditate until a specific time';
      case TimerMode.unlimited:
        return 'Meditate without a timer';
    }
  }

  String get iconName {
    switch (this) {
      case TimerMode.timed:
        return 'timelapse';
      case TimerMode.endAt:
        return 'schedule';
      case TimerMode.unlimited:
        return 'infinity';
    }
  }

  static TimerMode fromString(String value) {
    switch (value) {
      case 'timed':
        return TimerMode.timed;
      case 'endAt':
        return TimerMode.endAt;
      case 'unlimited':
        return TimerMode.unlimited;
      default:
        return TimerMode.timed;
    }
  }

  String get asString => name;
}
