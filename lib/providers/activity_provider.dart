import 'package:flutter/foundation.dart';

import '../models/activity.dart';

class ActivityProvider extends ChangeNotifier {
  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  void replace(List<Activity> activities) {
    _activities = activities;
    notifyListeners();
  }
}
