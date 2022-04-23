import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/progress/progress_cubit.dart';
import '../model/progress/progress.dart';
import '../model/progress/world_progress.dart';
import '../model/world.dart';

/// Builder for progress cubit.
class WorldProgressCubitBuilder extends StatelessWidget {
  /// Label for world.
  final World world;

  /// Builder for child widget.
  final Widget Function(BuildContext context, WorldProgress progress) builder;

  /// Builder for progress cubit.
  const WorldProgressCubitBuilder({required this.world, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, Progress>(
      builder: (context, state) {
        final _progress = state.getWorld(world);
        return builder(context, _progress);
      },
    );
  }
}