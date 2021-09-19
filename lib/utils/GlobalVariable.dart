import 'package:flutter/material.dart';

/// Global variables
/// * [GlobalKey<NavigatorState>]
class GlobalVariable {

  /// This global key is used in material app for navigation through firebase notifications.
  /// [navState] usage can be found in [notification_notifier.dart] file.
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}