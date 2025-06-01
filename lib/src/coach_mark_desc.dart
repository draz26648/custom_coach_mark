import 'package:flutter/material.dart';
import 'coach_mark_target.dart';

/// Widget for displaying the description tooltip for a coach mark target
class CoachMarkDescWidget extends StatelessWidget {
  /// The description to display
  final CoachMarkDesc description;
  
  /// The position of the target
  final Rect targetRect;
  
  /// The size of the screen
  final Size screenSize;
  
  /// The current page index
  final int currentIndex;
  
  /// The total number of pages
  final int totalPages;
  
  /// Callback when the next button is pressed
  final VoidCallback onNext;
  
  /// Callback when the previous button is pressed
  final VoidCallback onPrevious;
  
  /// Callback when the skip button is pressed
  final VoidCallback onSkip;
  
  /// Whether there is a next page
  final bool hasNext;
  
  /// Whether there is a previous page
  final bool hasPrevious;

  /// Constructor for creating a coach mark description widget
  const CoachMarkDescWidget({
    Key? key,
    required this.description,
    required this.targetRect,
    required this.screenSize,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.hasNext,
    required this.hasPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the position of the tooltip based on the target position and alignment
    final position = _calculatePosition(context);
    
    // If a custom tooltip builder is provided, use it
    if (description.tooltipBuilder != null) {
      // Create the data object for the builder
      final descData = CoachMarkDescData(
        title: description.title,
        content: description.content,
        currentIndex: currentIndex,
        totalPages: totalPages,
        hasNext: hasNext,
        hasPrevious: hasPrevious,
        alignment: description.alignment,
        titleStyle: description.titleStyle,
        contentStyle: description.contentStyle,
        backgroundColor: description.backgroundColor,
        arrowRadius: description.arrowRadius,
        onNext: onNext,
        onPrevious: onPrevious,
        onSkip: onSkip,
      );
      
      // Return the positioned custom tooltip
      return Positioned(
        left: position.left,
        top: position.top,
        child: description.tooltipBuilder!(context, descData),
      );
    }
    
    // Default text styles
    final defaultTitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    
    final defaultContentStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    
    // Default decoration
    final defaultDecoration = BoxDecoration(
      color: description.backgroundColor ?? Colors.blue,
      borderRadius: description.borderRadius ?? BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    );

    return Positioned(
      left: position.left,
      top: position.top,
      child: Container(
        width: position.width,
        constraints: BoxConstraints(
          maxWidth: description.maxWidth ?? screenSize.width * 0.8,
        ),
        decoration: description.tooltipDecoration ?? defaultDecoration,
        child: Stack(
          clipBehavior: Clip.none, // Allow arrow to overflow outside the container
          children: [
            // Tooltip arrow
            if (description.showArrow && _shouldShowArrow())
              _buildArrow(),
            
            // Content
            Padding(
              padding: description.contentPadding ?? const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  if (description.title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        description.title!,
                        style: description.titleStyle ?? defaultTitleStyle,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  
                  // Content
                  Text(
                    description.content,
                    style: description.contentStyle ?? defaultContentStyle,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  
                  // Navigation buttons
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip button
                      description.skipButtonBuilder != null
                          ? description.skipButtonBuilder!(onSkip)
                          : TextButton(
                              onPressed: onSkip,
                              child: Text(
                                'Skip',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                      
                      // Pagination indicator
                      description.paginationBuilder != null
                          ? description.paginationBuilder!(currentIndex, totalPages)
                          : Row(
                              children: List.generate(
                                totalPages,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == currentIndex
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                      
                      // Navigation buttons
                      Row(
                        children: [
                          // Previous button
                          if (hasPrevious)
                            description.previousButtonBuilder != null
                                ? description.previousButtonBuilder!(onPrevious)
                                : IconButton(
                                    icon: Icon(Icons.arrow_back, color: Colors.white),
                                    onPressed: onPrevious,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    iconSize: 20,
                                  ),
                          
                          // Next/Finish button
                          description.nextButtonBuilder != null
                              ? description.nextButtonBuilder!(onNext, !hasNext)
                              : IconButton(
                                  icon: Icon(
                                    hasNext ? Icons.arrow_forward : Icons.check,
                                    color: Colors.white,
                                  ),
                                  onPressed: onNext,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  iconSize: 20,
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate the position of the tooltip based on the target position and alignment
  _TooltipPosition _calculatePosition(BuildContext context) {
    double left = 0;
    double top = 0;
    double width = 300; // Default width
    final padding = 30.0; // Increased padding from the target for better spacing
    final tooltipHeight = 150.0; // Approximate height of tooltip
    
    // Adjust width based on maxWidth if provided
    if (description.maxWidth != null && description.maxWidth! < width) {
      width = description.maxWidth!;
    }
    
    switch (description.alignment) {
      case CoachMarkAlignment.bottom:
        left = targetRect.left + (targetRect.width - width) / 2;
        top = targetRect.bottom + padding;
        break;
      case CoachMarkAlignment.top:
        left = targetRect.left + (targetRect.width - width) / 2;
        top = targetRect.top - padding - tooltipHeight;
        break;
      case CoachMarkAlignment.left:
        left = targetRect.left - width - padding;
        top = targetRect.top + (targetRect.height - tooltipHeight) / 2;
        break;
      case CoachMarkAlignment.right:
        left = targetRect.right + padding;
        top = targetRect.top + (targetRect.height - tooltipHeight) / 2;
        break;
      case CoachMarkAlignment.topLeft:
        left = targetRect.left;
        top = targetRect.top - padding - tooltipHeight;
        break;
      case CoachMarkAlignment.topRight:
        left = targetRect.right - width;
        top = targetRect.top - padding - tooltipHeight;
        break;
      case CoachMarkAlignment.bottomLeft:
        left = targetRect.left;
        top = targetRect.bottom + padding;
        break;
      case CoachMarkAlignment.bottomRight:
        left = targetRect.right - width;
        top = targetRect.bottom + padding;
        break;
    }
    
    // Ensure the tooltip stays within the screen bounds with some margin
    final screenMargin = 10.0;
    if (left < screenMargin) {
      left = screenMargin;
    } else if (left + width > screenSize.width - screenMargin) {
      left = screenSize.width - width - screenMargin;
    }
    
    if (top < screenMargin) {
      top = screenMargin;
    } else if (top + tooltipHeight > screenSize.height - screenMargin) {
      top = screenSize.height - tooltipHeight - screenMargin;
    }
    
    return _TooltipPosition(left, top, width);
  }

  /// Check if the arrow should be shown
  bool _shouldShowArrow() {
    return description.alignment != CoachMarkAlignment.topLeft &&
           description.alignment != CoachMarkAlignment.topRight &&
           description.alignment != CoachMarkAlignment.bottomLeft &&
           description.alignment != CoachMarkAlignment.bottomRight;
  }

  /// Build the arrow for the tooltip
  Widget _buildArrow() {
    final arrowSize = description.arrowSize;
    final arrowRadius = description.arrowRadius;
    final arrowColor = description.arrowColor ?? description.backgroundColor ?? Colors.blue;
    
    // Calculate tooltip width (same as in _calculatePosition)
    double tooltipWidth = 300;
    if (description.maxWidth != null && description.maxWidth! < tooltipWidth) {
      tooltipWidth = description.maxWidth!;
    }
    
    switch (description.alignment) {
      case CoachMarkAlignment.bottom:
        // Position arrow at the top-center of the tooltip, OUTSIDE the container
        return Positioned(
          left: tooltipWidth / 2 - arrowSize / 2,
          top: -arrowSize, // Position outside the container
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.up,
              color: arrowColor,
              arrowRadius: arrowRadius,
            ),
          ),
        );
      case CoachMarkAlignment.top:
        // Position arrow at the bottom-center of the tooltip, OUTSIDE the container
        return Positioned(
          left: tooltipWidth / 2 - arrowSize / 2,
          bottom: -arrowSize, // Position outside the container
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.down,
              color: arrowColor,
              arrowRadius: arrowRadius,
            ),
          ),
        );
      case CoachMarkAlignment.left:
        // Position arrow at the right-center of the tooltip, OUTSIDE the container
        return Positioned(
          right: -arrowSize, // Position outside the container
          top: 75 - arrowSize / 2, // Center vertically (150/2 = 75)
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.right,
              color: arrowColor,
              arrowRadius: arrowRadius,
            ),
          ),
        );
      case CoachMarkAlignment.right:
        // Position arrow at the left-center of the tooltip, OUTSIDE the container
        return Positioned(
          left: -arrowSize, // Position outside the container
          top: 75 - arrowSize / 2, // Center vertically
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.left,
              color: arrowColor,
              arrowRadius: arrowRadius,
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}

/// Helper class for positioning the tooltip
class _TooltipPosition {
  final double left;
  final double top;
  final double width;
  
  _TooltipPosition(this.left, this.top, this.width);
}

/// Enum for arrow directions
enum ArrowDirection {
  up,
  down,
  left,
  right,
}

/// Custom painter for drawing the arrow
class ArrowPainter extends CustomPainter {
  final ArrowDirection direction;
  final Color color;
  final double arrowRadius;
  
  ArrowPainter({
    required this.direction,
    required this.color,
    this.arrowRadius = 0.0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    switch (direction) {
      case ArrowDirection.up:
        if (arrowRadius <= 0) {
          // Sharp arrow
          path.moveTo(0, size.height);
          path.lineTo(size.width / 2, 0);
          path.lineTo(size.width, size.height);
        } else {
          // Rounded arrow
          final radius = arrowRadius.clamp(0.0, size.width / 4);
          path.moveTo(radius, size.height);
          path.lineTo(size.width / 2, radius);
          path.lineTo(size.width - radius, size.height);
          path.arcToPoint(
            Offset(radius, size.height),
            radius: Radius.circular(radius),
            clockwise: false,
          );
        }
        path.close();
        break;
      case ArrowDirection.down:
        if (arrowRadius <= 0) {
          // Sharp arrow
          path.moveTo(0, 0);
          path.lineTo(size.width / 2, size.height);
          path.lineTo(size.width, 0);
        } else {
          // Rounded arrow
          final radius = arrowRadius.clamp(0.0, size.width / 4);
          path.moveTo(radius, 0);
          path.lineTo(size.width - radius, 0);
          path.arcToPoint(
            Offset(size.width / 2 + radius, size.height - radius),
            radius: Radius.circular(radius),
            clockwise: true,
          );
          path.lineTo(size.width / 2, size.height);
          path.lineTo(size.width / 2 - radius, size.height - radius);
          path.arcToPoint(
            Offset(radius, 0),
            radius: Radius.circular(radius),
            clockwise: true,
          );
        }
        path.close();
        break;
      case ArrowDirection.left:
        if (arrowRadius <= 0) {
          // Sharp arrow
          path.moveTo(size.width, 0);
          path.lineTo(0, size.height / 2);
          path.lineTo(size.width, size.height);
        } else {
          // Rounded arrow
          final radius = arrowRadius.clamp(0.0, size.height / 4);
          path.moveTo(size.width, radius);
          path.lineTo(radius, size.height / 2);
          path.lineTo(size.width, size.height - radius);
          path.arcToPoint(
            Offset(size.width, radius),
            radius: Radius.circular(radius),
            clockwise: false,
          );
        }
        path.close();
        break;
      case ArrowDirection.right:
        if (arrowRadius <= 0) {
          // Sharp arrow
          path.moveTo(0, 0);
          path.lineTo(size.width, size.height / 2);
          path.lineTo(0, size.height);
        } else {
          // Rounded arrow
          final radius = arrowRadius.clamp(0.0, size.height / 4);
          path.moveTo(0, radius);
          path.lineTo(0, size.height - radius);
          path.arcToPoint(
            Offset(size.width - radius, size.height / 2),
            radius: Radius.circular(radius),
            clockwise: true,
          );
          path.arcToPoint(
            Offset(0, radius),
            radius: Radius.circular(radius),
            clockwise: true,
          );
        }
        path.close();
        break;
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
