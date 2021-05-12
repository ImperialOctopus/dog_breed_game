import 'level/level.dart';

/// Data structure for a world.
class World {
  /// World's unique id string.
  final String id;

  /// Text to display as title.
  final String title;

  /// Text for description.
  final String description;

  /// Text of subtitle.
  final String? subtitle;

  /// Icon image.
  final String imagePath;

  /// List of levels.
  final List<Level> levels;

  /// Data structure for a world.
  const World({
    required this.id,
    required this.title,
    this.subtitle,
    required this.description,
    required this.imagePath,
    required this.levels,
  });
}
