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
                      ),
                    ),
                  
                  // Content
                  Text(
                    description.content,
                    style: description.contentStyle ?? defaultContentStyle,
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
    final padding = 20.0; // Padding from the target
    
    switch (description.alignment) {
      case CoachMarkAlignment.bottom:
        left = targetRect.left + (targetRect.width - width) / 2;
        top = targetRect.bottom + padding;
        break;
      case CoachMarkAlignment.top:
        left = targetRect.left + (targetRect.width - width) / 2;
        top = targetRect.top - padding - 150; // Approximate height
        break;
      case CoachMarkAlignment.left:
        left = targetRect.left - width - padding;
        top = targetRect.top + (targetRect.height - 150) / 2;
        break;
      case CoachMarkAlignment.right:
        left = targetRect.right + padding;
        top = targetRect.top + (targetRect.height - 150) / 2;
        break;
      case CoachMarkAlignment.topLeft:
        left = targetRect.left;
        top = targetRect.top - padding - 150;
        break;
      case CoachMarkAlignment.topRight:
        left = targetRect.right - width;
        top = targetRect.top - padding - 150;
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
    
    // Ensure the tooltip stays within the screen bounds
    if (left < 0) {
      left = 0;
    } else if (left + width > screenSize.width) {
      left = screenSize.width - width;
    }
    
    if (top < 0) {
      top = 0;
    } else if (top + 150 > screenSize.height) {
      top = screenSize.height - 150;
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
    final arrowColor = description.arrowColor ?? description.backgroundColor ?? Colors.blue;
    double left = 0;
    double top = 0;
    
    switch (description.alignment) {
      case CoachMarkAlignment.bottom:
        left = (targetRect.width - arrowSize) / 2;
        top = 0;
        return Positioned(
          left: left,
          top: top,
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.up,
              color: arrowColor,
            ),
          ),
        );
      case CoachMarkAlignment.top:
        left = (targetRect.width - arrowSize) / 2;
        top = 150 - arrowSize;
        return Positioned(
          left: left,
          bottom: 0,
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.down,
              color: arrowColor,
            ),
          ),
        );
      case CoachMarkAlignment.left:
        left = 300 - arrowSize;
        top = (targetRect.height - arrowSize) / 2;
        return Positioned(
          right: 0,
          top: top,
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.right,
              color: arrowColor,
            ),
          ),
        );
      case CoachMarkAlignment.right:
        left = 0;
        top = (targetRect.height - arrowSize) / 2;
        return Positioned(
          left: left,
          top: top,
          child: CustomPaint(
            size: Size(arrowSize, arrowSize),
            painter: ArrowPainter(
              direction: ArrowDirection.left,
              color: arrowColor,
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
  
  ArrowPainter({
    required this.direction,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    switch (direction) {
      case ArrowDirection.up:
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        path.close();
        break;
      case ArrowDirection.down:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        path.close();
        break;
      case ArrowDirection.left:
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        path.close();
        break;
      case ArrowDirection.right:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
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
