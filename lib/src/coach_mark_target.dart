import 'package:flutter/material.dart';

/// Represents a target widget to be highlighted in the coach mark
class CoachMarkTarget {
  /// The key of the widget to be highlighted
  final GlobalKey key;
  
  /// The shape of the highlight
  final ShapeBorder shape;
  
  /// Custom padding to apply around the target
  final EdgeInsets? padding;
  
  /// Description to show for this target
  final CoachMarkDesc description;

  /// Constructor for creating a coach mark target
  CoachMarkTarget({
    required this.key,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.padding,
    required this.description,
  });

  /// Get the target's position and size on the screen
  Rect getTargetPosition(BuildContext context) {
    try {
      final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      
      if (renderBox == null) {
        return Rect.zero;
      }
      
      final Size size = renderBox.size;
      final Offset position = renderBox.localToGlobal(Offset.zero);
      
      // Apply padding if provided
      if (padding != null) {
        return Rect.fromLTWH(
          position.dx - padding!.left,
          position.dy - padding!.top,
          size.width + padding!.left + padding!.right,
          size.height + padding!.top + padding!.bottom,
        );
      }
      
      return Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    } catch (e) {
      debugPrint('Error getting target position: $e');
      return Rect.zero;
    }
  }
}

/// Represents the description to be shown for a target
class CoachMarkDesc {
  /// The title of the description
  final String? title;
  
  /// The content of the description
  final String content;
  
  /// The text style for the title
  final TextStyle? titleStyle;
  
  /// The text style for the content
  final TextStyle? contentStyle;
  
  /// The alignment of the description relative to the target
  final CoachMarkAlignment alignment;
  
  /// The background color of the description box
  final Color? backgroundColor;

  /// Constructor for creating a coach mark description
  CoachMarkDesc({
    this.title,
    required this.content,
    this.titleStyle,
    this.contentStyle,
    this.alignment = CoachMarkAlignment.bottom,
    this.backgroundColor,
  });
}

/// Enum representing the alignment of the description relative to the target
enum CoachMarkAlignment {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
