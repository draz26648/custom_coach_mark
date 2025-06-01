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

<img src="https://raw.githubusercontent.com/yourusername/custom_coach_mark/main/screenshots/example.png" alt="Custom Coach Mark Example" width="300"/>

## Installation

```yaml
dependencies:
  custom_coach_mark: ^0.1.0
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

Contributions are welcome! If you find a bug or want a feature, please open an issue on GitHub.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
