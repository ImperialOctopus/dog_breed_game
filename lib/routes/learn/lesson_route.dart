import 'package:flutter/material.dart';

import '../../model/level/lesson.dart';
import '../../model/level/level.dart';
import '../../model/level/quiz.dart';
import '../../model/world.dart';
import '../../screen/learn/level/lesson_screen.dart';
import '../../screen/learn/level/quiz_screen.dart';
import '../provides_page.dart';

/// Route for a level.
class LevelRoute extends StatelessWidget implements ProvidesPage<void> {
  /// World the level belongs to.
  final World world;

  /// Level to display.
  final Level level;

  /// Route for a level.
  const LevelRoute({required this.world, required this.level});

  @override
  Widget build(BuildContext context) {
    // Local variable to allow compiler to promote type.
    final _level = level;

    // Return screen for the type of lesson this is.
    if (_level is Quiz) {
      return QuizScreen(world: world, quiz: _level);
    }
    if (_level is Lesson) {
      return LessonScreen(world: world, lesson: _level);
    }

    // Falls through if level is an unsupported type.
    throw FallThroughError();
  }

  @override
  Page<void> get page => MaterialPage(child: this);
}