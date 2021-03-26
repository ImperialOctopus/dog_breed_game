import 'package:flutter/material.dart';

import 'bloc/router_state.dart';
import 'learn/learn_route.dart';
import 'learn/lesson_route.dart';
import 'learn/quiz_route.dart';
import 'learn/result_route.dart';
import 'learn/world_route.dart';
import 'menu/menu_route.dart';

/// Build the app's routes from the state of the router bloc.
List<Page> buildRoutes(RouterState routerState) {
  return [
    const MenuRoute().page,
    if (routerState is RouterStateLearn) const LearnRoute().page,
    if (routerState is RouterStateLearnWorld)
      WorldRoute(world: routerState.world).page,
    if (routerState is RouterStateLearnLesson)
      LessonRoute(lesson: routerState.level).page,
    if (routerState is RouterStateLearnQuiz)
      if (routerState is RouterStateLearnResult)
        ResultRoute(quiz: routerState.level, score: routerState.score).page
      else
        QuizRoute(
          quiz: routerState.level,
        ).page,
  ];
}
