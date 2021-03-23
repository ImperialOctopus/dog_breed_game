import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/fixed_height_cover_box.dart';
import '../../../component/level_header.dart';
import '../../../model/level/level.dart';
import '../lesson/lesson_screen.dart';
import '../quiz/quiz_screen.dart';

/// Pages in level select screen.
class LevelSelectPage extends StatelessWidget {
  /// Level to display.
  final Level level;

  /// Pages in level select screen.
  const LevelSelectPage({required this.level});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Column(
            children: [
              LevelHeader(
                icon: level.icon,
                title: level.title,
                subtitle: level.subtitle,
              ),
              FixedHeightCoverBox(
                child: level.icon,
                height: 300,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: level.subtitle,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (level != null)
                    TextButton(
                      child: const Text('Lesson'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<LessonScreen>(
                            builder: (context) =>
                                LessonScreen(lesson: level.lesson!)),
                      ),
                    ),
                  if (level.quiz != null)
                    TextButton(
                      child: BlocBuilder<ProgressBloc, ProgressState>(
                        builder: (context, state) {
                          if (state is ProgressLoaded) {
                            final score =
                                state.getProgressByLevel(level).quizScore;
                            return Column(
                              children: [
                                const Text('Quiz'),
                                if (score != 0)
                                  Text((score * 100).toStringAsFixed(0) + '%')
                              ],
                            );
                          } else {
                            return const Text('Quiz');
                          }
                        },
                      ),
                      onPressed: () => Navigator.of(context).push<void>(
                          MaterialPageRoute<QuizScreen>(
                              builder: (context) => QuizScreen(level: level))),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}