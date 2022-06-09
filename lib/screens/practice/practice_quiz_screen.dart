import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/practice/practice_end_state.dart';
import '../../model/practice/practice_result.dart';
import '../../model/practice/practice_settings.dart';
import '../../model/questions/question.dart';
import '../../repository/question/question_repository.dart';
import '../../router/actions/router_end_practice.dart';
import '../../router/router_bloc.dart';
import '../../theme/animation.dart';
import '../question_page/question_page.dart';
import 'components/settings_info_bar.dart';

/// Screen for the practice quiz.
class PracticeQuizScreen extends StatefulWidget {
  /// Settings for the quiz to play.
  final PracticeSettings settings;

  /// Screen for the practice quiz.
  const PracticeQuizScreen({required this.settings});

  @override
  _PracticeQuizScreenState createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  late final Question Function() questionGenerator;
  late Question currentQuestion;

  PracticeEndState endState = PracticeEndState.continuing;
  int questionsAnswered = 0;
  int mistakesMade = 0;

  double get progress => widget.settings.questionNumber != null
      ? questionsAnswered / widget.settings.questionNumber!
      : 0;

  static const _introSwitchDuration = AnimationTheme.quizSwitcherDuration;

  @override
  void initState() {
    super.initState();

    questionGenerator = RepositoryProvider.of<QuestionRepository>(context)
        .getQuestionGenerator(difficulty: widget.settings.difficulty);
    currentQuestion = questionGenerator();
  }

  void onQuestionAnswered(bool correct) {
    setState(() {
      if (!correct) {
        mistakesMade += 1;

        if (widget.settings.lives != null &&
            mistakesMade >= widget.settings.lives!) {
          // ran out of lives
          endState = PracticeEndState.lives;
        }
      }
      questionsAnswered += 1;

      if (widget.settings.questionNumber != null &&
          questionsAnswered >= widget.settings.questionNumber!) {
        // ran out of questions
        endState = PracticeEndState.questions;
      }
    });
  }

  void onTimeExpires() {
    setState(() {
      endState = PracticeEndState.time;
    });
  }

  void onConcedePressed() {
    endState = PracticeEndState.concede;
    onNextPressed();
  }

  void onNextPressed() {
    if (endState != PracticeEndState.continuing) {
      setState(() {
        BlocProvider.of<RouterBloc>(context).add(
          RouterEndPractice(
              settings: widget.settings,
              result: PracticeResult(
                mistakes: mistakesMade,
                score: questionsAnswered - mistakesMade,
                practiceEndState: endState,
              )),
        );
      });
      return;
    }
    setState(() {
      // Repeat generation if we get the same question again.
      var _nextQuestion = questionGenerator();
      while (_nextQuestion == currentQuestion) {
        _nextQuestion = questionGenerator();
      }
      // Move on to next question.
      currentQuestion = _nextQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: onConcedePressed, icon: const Icon(Icons.cancel)),
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: _introSwitchDuration,
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                switchOutCurve: const Threshold(0),
                switchInCurve: Curves.ease,
                child: QuestionPage(
                  key: ValueKey(currentQuestion),
                  question: currentQuestion,
                  progress: progress,
                  quizOver: endState != PracticeEndState.continuing,
                  onQuestionAnswered: onQuestionAnswered,
                  nextButtonContent: endState == PracticeEndState.continuing
                      ? const Text('Next')
                      : const Text('Results'),
                  onNextPressed: onNextPressed,
                ),
              ),
            ),
            SettingsInfoBar(
                difficulty: widget.settings.difficulty,
                lives: widget.settings.lives,
                mistakes: mistakesMade,
                timeEnabled: widget.settings.time),
          ],
        ),
      ),
    );
  }
}
