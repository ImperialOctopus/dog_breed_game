import 'package:flutter/material.dart';

import '../../../../model/learn/knowledge_check.dart';

/// Introduces end-of-lesson quiz.
class KnowledgeCheckIntro extends StatelessWidget {
  /// Quiz this introduces.
  final KnowledgeCheck knowledgeCheck;

  /// Callback for next button is pressed.
  final void Function() onNext;

  /// Introduces end-of-lesson quiz.
  const KnowledgeCheckIntro(
      {required this.knowledgeCheck, required this.onNext});

  static const double _headerImageHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: _headerImageHeight,
              child: Hero(
                tag: knowledgeCheck,
                child: Image.asset(knowledgeCheck.imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(knowledgeCheck.title),
                  if (knowledgeCheck.subtitle != null)
                    Text(knowledgeCheck.subtitle!),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: ElevatedButton(
                  onPressed: onNext,
                  child: const Text('Start'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
