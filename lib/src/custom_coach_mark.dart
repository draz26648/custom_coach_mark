import 'package:flutter/material.dart';
import 'coach_mark_controller.dart';
import 'coach_mark_desc.dart';

/// Main widget for displaying the coach mark tutorial
class CustomCoachMark extends StatefulWidget {
  /// The controller for managing the coach mark
  final CoachMarkController controller;
  
  /// The child widget to display
  final Widget child;
  
  /// The color of the overlay
  final Color overlayColor;
  
  /// The opacity of the overlay
  final double overlayOpacity;
  
  /// Whether to close the coach mark when tapping outside the target
  final bool closeOnTapOutside;

  /// Constructor for creating a custom coach mark
  const CustomCoachMark({
    Key? key,
    required this.controller,
    required this.child,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.8,
    this.closeOnTapOutside = true,
  }) : super(key: key);

  @override
  State<CustomCoachMark> createState() => _CustomCoachMarkState();
}

class _CustomCoachMarkState extends State<CustomCoachMark> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Main content
          widget.child,
          
          // Coach mark overlay
          if (widget.controller.isShowing)
            _buildCoachMarkOverlay(context),
        ],
      ),
    );
  }

  Widget _buildCoachMarkOverlay(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final currentTarget = widget.controller.currentTarget;
    final targetRect = currentTarget.getTargetPosition(context);
    
    return Stack(
      children: [
        // Overlay with hole
        _buildOverlayWithHole(context, targetRect),
        
        // Description tooltip
        CoachMarkDescWidget(
          description: currentTarget.description,
          targetRect: targetRect,
          screenSize: screenSize,
          currentIndex: widget.controller.currentIndex,
          totalPages: widget.controller.targetCount,
          onNext: widget.controller.next,
          onPrevious: widget.controller.previous,
          onSkip: widget.controller.skip,
          hasNext: widget.controller.hasNext,
          hasPrevious: widget.controller.hasPrevious,
        ),
      ],
    );
  }

  Widget _buildOverlayWithHole(BuildContext context, Rect targetRect) {
    return GestureDetector(
      onTap: widget.closeOnTapOutside ? widget.controller.next : null,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: HolePainter(
          rect: targetRect,
          color: widget.overlayColor.withOpacity(widget.overlayOpacity),
          shape: widget.controller.currentTarget.shape,
        ),
      ),
    );
  }
}

/// Custom painter for drawing the overlay with a hole
class HolePainter extends CustomPainter {
  final Rect rect;
  final Color color;
  final ShapeBorder shape;

  HolePainter({
    required this.rect,
    required this.color,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the overlay
    final paint = Paint()..color = color;
    
    // Create a path that covers the entire screen
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Create a path for the hole
    final holePath = Path();
    
    // Add padding to the highlight rect for better spacing
    final highlightPadding = 8.0;
    final highlightRect = Rect.fromLTWH(
      rect.left - highlightPadding,
      rect.top - highlightPadding,
      rect.width + (highlightPadding * 2),
      rect.height + (highlightPadding * 2),
    );
    
    // Add the shape to the hole path
    if (shape is CircleBorder) {
      final center = highlightRect.center;
      final radius = highlightRect.width > highlightRect.height ? 
          highlightRect.width / 2 : highlightRect.height / 2;
      holePath.addOval(Rect.fromCircle(center: center, radius: radius));
    } else if (shape is RoundedRectangleBorder) {
      final borderRadius = (shape as RoundedRectangleBorder).borderRadius;
      if (borderRadius is BorderRadius) {
        holePath.addRRect(RRect.fromRectAndCorners(
          highlightRect,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ));
      } else {
        holePath.addRect(highlightRect);
      }
    } else if (shape is OvalBorder) {
      holePath.addOval(highlightRect);
    } else {
      holePath.addRect(highlightRect);
    }
    
    // Subtract the hole from the overlay
    final finalPath = Path.combine(PathOperation.difference, path, holePath);
    
    // Draw the final path
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is HolePainter) {
      return rect != oldDelegate.rect ||
             color != oldDelegate.color ||
             shape != oldDelegate.shape;
    }
    return true;
  }
}
