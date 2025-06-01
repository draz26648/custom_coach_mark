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
  
  /// Custom decoration for the tooltip container
  final BoxDecoration? tooltipDecoration;
  
  /// Padding for the tooltip content
  final EdgeInsets? contentPadding;
  
  /// Custom widget builder for the tooltip
  /// If provided, this will override the default tooltip design
  /// The builder receives the description data and navigation callbacks
  final Widget Function(BuildContext context, CoachMarkDescData descData)? tooltipBuilder;
  
  /// Custom builder for the skip button
  final Widget Function(VoidCallback onSkip)? skipButtonBuilder;
  
  /// Custom builder for the next button
  final Widget Function(VoidCallback onNext, bool isLastStep)? nextButtonBuilder;
  
  /// Custom builder for the previous button
  final Widget Function(VoidCallback onPrevious)? previousButtonBuilder;
  
  /// Custom builder for the pagination indicators
  final Widget Function(int currentIndex, int totalCount)? paginationBuilder;
  
  /// Border radius for the tooltip
  final BorderRadius? borderRadius;
  
  /// Maximum width for the tooltip
  final double? maxWidth;
  
  /// Whether to show the arrow pointer
  final bool showArrow;
  
  /// Arrow size
  final double arrowSize;
  
  /// Arrow radius for rounded corners (0 for sharp arrow)
  final double arrowRadius;
  
  /// Arrow color (defaults to backgroundColor if not specified)
  final Color? arrowColor;

  /// Constructor for creating a coach mark description
  CoachMarkDesc({
    this.title,
    required this.content,
    this.titleStyle,
    this.contentStyle,
    this.alignment = CoachMarkAlignment.bottom,
    this.backgroundColor,
    this.tooltipDecoration,
    this.contentPadding,
    this.tooltipBuilder,
    this.skipButtonBuilder,
    this.nextButtonBuilder,
    this.previousButtonBuilder,
    this.paginationBuilder,
    this.borderRadius,
    this.maxWidth,
    this.showArrow = true,
    this.arrowSize = 10.0,
    this.arrowRadius = 0.0,
    this.arrowColor,
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

/// Data class for the tooltip builder
class CoachMarkDescData {
  /// The title of the description
  final String? title;
  
  /// The content of the description
  final String content;
  
  /// The current page index
  final int currentIndex;
  
  /// The total number of pages
  final int totalPages;
  
  /// Whether there is a next page
  final bool hasNext;
  
  /// Whether there is a previous page
  final bool hasPrevious;
  
  /// The alignment of the description relative to the target
  final CoachMarkAlignment alignment;
  
  /// The text style for the title
  final TextStyle? titleStyle;
  
  /// The text style for the content
  final TextStyle? contentStyle;
  
  /// The background color of the description box
  final Color? backgroundColor;
  
  /// Arrow radius for rounded corners (0 for sharp arrow)
  final double? arrowRadius;
  
  /// Callback when the next button is pressed
  final VoidCallback onNext;
  
  /// Callback when the previous button is pressed
  final VoidCallback onPrevious;
  
  /// Callback when the skip button is pressed
  final VoidCallback onSkip;
  
  /// Constructor for the tooltip data
  CoachMarkDescData({
    this.title,
    required this.content,
    required this.currentIndex,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.alignment,
    this.titleStyle,
    this.contentStyle,
    this.backgroundColor,
    this.arrowRadius,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
  });
}
