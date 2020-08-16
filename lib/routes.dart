import 'package:flutter/material.dart';
import 'package:summy/screens/game.dart';
import 'package:summy/screens/home.dart';
import 'package:summy/screens/settings.dart';

enum Routes {
  Home,
  Game,
  Settings,
}

final Map<String, WidgetBuilder> routes = {
  Routes.Home.toString(): (_) => HomeScreen(),
  Routes.Game.toString(): (_) => GameScreen(),
  Routes.Settings.toString(): (_) => SettingsScreen(),
};
