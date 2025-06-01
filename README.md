# custom_coach_mark
# Custom Coach Mark

[![pub package](https://img.shields.io/pub/v/custom_coach_mark.svg)](https://pub.dev/packages/custom_coach_mark)

A customizable coach mark package for Flutter that creates beautiful, responsive tutorials and onboarding experiences. This package was built from scratch to provide maximum flexibility and a modern design.  

## Features

- **No animations** - Clean, static display without distracting transitions
- **Auto-scaling highlight** - Automatically adapts to the target widget size
- **Pagination system** - Navigate through multiple tutorial steps with ease
- **Responsive design** - Works with any screen size and orientation
- **Tooltip-style descriptions** - Modern, attractive tooltips with customizable appearance
- **Highly customizable** - Control colors, shapes, positions, and more

<img src="https://raw.githubusercontent.com/draz26648/custom_coach_mark/main/screenshots/example.png" alt="Custom Coach Mark Example" width="300"/>

## Installation

```yaml
dependencies:
  custom_coach_mark: ^0.2.0
```

## Usage

### Basic Example

```dart
import 'package:custom_coach_mark/custom_coach_mark.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create global keys for the widgets you want to highlight
  final GlobalKey buttonKey = GlobalKey();
  final GlobalKey menuKey = GlobalKey();
  
  // Create a controller
  late CoachMarkController controller;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize the controller with targets
    controller = CoachMarkController(
      targets: [
        CoachMarkTarget(
          key: buttonKey,
          shape: CircleBorder(),
          description: CoachMarkDesc(
            title: 'Add Item',
            content: 'Tap here to add a new item',
            alignment: CoachMarkAlignment.bottom,
            backgroundColor: Colors.blue,
          ),
        ),
        CoachMarkTarget(
          key: menuKey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          description: CoachMarkDesc(
            title: 'Menu',
            content: 'Access app settings and more',
            alignment: CoachMarkAlignment.right,
            backgroundColor: Colors.orange,
          ),
        ),
      ],
      onFinish: () {
        print('Tutorial completed!');
      },
      onSkip: () {
        print('Tutorial skipped');
      },
    );
    
    // Show the coach mark after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.show(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomCoachMark(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Custom Coach Mark Demo'),
          actions: [
            IconButton(
              key: menuKey,
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: Text('Welcome to Custom Coach Mark!'),
        ),
        floatingActionButton: FloatingActionButton(
          key: buttonKey,
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

## Customization

### Target Customization

```dart
CoachMarkTarget(
  key: widgetKey,
  // Change the shape of the highlight
  shape: OvalBorder(),  // CircleBorder(), RoundedRectangleBorder(), etc.
  
  // Add padding around the target
  padding: EdgeInsets.all(8),
  
  // Customize the description
  description: CoachMarkDesc(
    title: 'Custom Title',
    content: 'This is a custom description',
    alignment: CoachMarkAlignment.topRight,
    backgroundColor: Colors.purple,
    titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    contentStyle: TextStyle(fontSize: 16),
  ),
);
```

### Coach Mark Customization

```dart
CustomCoachMark(
  controller: controller,
  // Change the overlay color and opacity
  overlayColor: Colors.black,
  overlayOpacity: 0.7,
  
  // Control whether to close on tap outside
  closeOnTapOutside: true,
  
  child: YourApp(),
);
```

## Advanced Customization

The package offers extensive customization options:

### CoachMarkTarget

- `identify`: The GlobalKey of the widget to highlight
- `shape`: The shape of the highlight (circle, rectangle, oval, or custom shape)
- `padding`: Additional padding around the target widget
- `description`: The description to show for the target

### CoachMarkDesc

Basic Properties:
- `title`: The title of the description
- `content`: The content of the description
- `titleStyle`: The text style for the title
- `contentStyle`: The text style for the content
- `alignment`: The alignment of the description relative to the target
- `backgroundColor`: The background color of the description box

Advanced Styling:
- `tooltipDecoration`: Custom BoxDecoration for the tooltip container
- `contentPadding`: Custom padding for the tooltip content
- `borderRadius`: Border radius for the tooltip
- `maxWidth`: Maximum width for the tooltip

Arrow Customization:
- `showArrow`: Whether to show the arrow pointer
- `arrowSize`: Size of the arrow pointer
- `arrowColor`: Color of the arrow pointer

Custom Builders:
- `tooltipBuilder`: Completely custom tooltip builder that overrides the default design
- `skipButtonBuilder`: Custom builder for the skip button
- `nextButtonBuilder`: Custom builder for the next button
- `previousButtonBuilder`: Custom builder for the previous button
- `paginationBuilder`: Custom builder for the pagination indicators

### CustomCoachMark

- `controller`: The controller for the coach mark
- `overlayColor`: The color of the overlay
- `overlayOpacity`: The opacity of the overlay (0.0 to 1.0)
- `child`: The child widget to display

## Advanced Customization Examples

### Custom Tooltip Style

```dart
CoachMarkDesc(
  title: 'Custom Style',
  content: 'This tooltip has custom styling',
  alignment: CoachMarkAlignment.bottom,
  backgroundColor: Colors.purple,
  borderRadius: BorderRadius.circular(12),
  maxWidth: 300,
  contentPadding: EdgeInsets.all(20),
  arrowSize: 15,
  titleStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  contentStyle: TextStyle(color: Colors.white70, fontSize: 16),
)
```

### Custom Decoration with Gradient

```dart
CoachMarkDesc(
  title: 'Gradient Background',
  content: 'This tooltip has a gradient background',
  alignment: CoachMarkAlignment.top,
  tooltipDecoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 15,
        offset: Offset(0, 8),
      ),
    ],
  ),
)
```

### Custom Button Builders

```dart
CoachMarkDesc(
  title: 'Custom Buttons',
  content: 'This tooltip has custom buttons',
  alignment: CoachMarkAlignment.bottom,
  backgroundColor: Colors.blue,
  skipButtonBuilder: (onSkip) => ElevatedButton(
    onPressed: onSkip,
    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    child: Text('Exit'),
  ),
  nextButtonBuilder: (onNext, isLastStep) => ElevatedButton(
    onPressed: onNext,
    child: Text(isLastStep ? 'Finish' : 'Next'),
  ),
  paginationBuilder: (currentIndex, totalCount) => Row(
    children: List.generate(
      totalCount,
      (index) => Container(
        width: 10,
        height: 10,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == currentIndex ? Colors.white : Colors.white30,
        ),
      ),
    ),
  ),
)
```

### Completely Custom Tooltip

```dart
CoachMarkDesc(
  content: 'This is a completely custom tooltip',
  alignment: CoachMarkAlignment.left,
  tooltipBuilder: (context, data) => Container(
    width: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.orangeAccent, width: 2),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CUSTOM TOOLTIP',
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        Text(
          data.content,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        // Custom navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: data.onSkip,
              child: Text('SKIP', style: TextStyle(color: Colors.red)),
            ),
            IconButton(
              onPressed: data.onNext,
              icon: Icon(
                data.hasNext ? Icons.arrow_forward : Icons.check,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

## API Reference

### CoachMarkTarget

| Property | Type | Description |
|----------|------|-------------|
| `key` | `GlobalKey` | The key of the widget to highlight |
| `shape` | `ShapeBorder` | The shape of the highlight |
| `padding` | `EdgeInsets?` | Optional padding around the target |
| `description` | `CoachMarkDesc` | Description to show for this target |

### CoachMarkDesc

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String?` | Optional title of the description |
| `content` | `String` | Content of the description |
| `titleStyle` | `TextStyle?` | Optional style for the title |
| `contentStyle` | `TextStyle?` | Optional style for the content |
| `alignment` | `CoachMarkAlignment` | Alignment of the description relative to the target |
| `backgroundColor` | `Color?` | Optional background color of the description box |
| `tooltipDecoration` | `BoxDecoration?` | Custom BoxDecoration for the tooltip container |
| `contentPadding` | `EdgeInsets?` | Custom padding for the tooltip content |
| `borderRadius` | `BorderRadius?` | Border radius for the tooltip |
| `maxWidth` | `double?` | Maximum width for the tooltip |
| `showArrow` | `bool?` | Whether to show the arrow pointer |
| `arrowSize` | `double?` | Size of the arrow pointer |
| `arrowColor` | `Color?` | Color of the arrow pointer |
| `tooltipBuilder` | `Widget Function(BuildContext, CoachMarkDescData)?` | Completely custom tooltip builder that overrides the default design |
| `skipButtonBuilder` | `Widget Function(Callback)?` | Custom builder for the skip button |
| `nextButtonBuilder` | `Widget Function(Callback, bool)?` | Custom builder for the next button |
| `previousButtonBuilder` | `Widget Function(Callback)?` | Custom builder for the previous button |
| `paginationBuilder` | `Widget Function(int, int)?` | Custom builder for the pagination indicators |

### CoachMarkController

| Method | Description |
|--------|-------------|
| `show(BuildContext context)` | Show the coach mark |
| `hide()` | Hide the coach mark |
| `skip()` | Skip the tutorial |
| `next()` | Move to the next target |
| `previous()` | Move to the previous target |
| `jumpTo(int index)` | Jump to a specific target |

## Contributing

Contributions are welcome! If you find a bug or want a feature, please open an issue on [GitHub](https://github.com/draz26648/custom_coach_mark/issues).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
