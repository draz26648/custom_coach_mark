import 'package:custom_coach_mark/custom_coach_mark.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Coach Mark Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create global keys for the widgets you want to highlight
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _titleKey = GlobalKey();
  
  // Create a controller
  late CoachMarkController _controller;
  
  // Track whether the tutorial has been shown
  bool _tutorialShown = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize the controller with targets
    _controller = CoachMarkController(
      targets: [
        CoachMarkTarget(
          key: _titleKey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          description: CoachMarkDesc(
            title: 'Welcome!',
            content: 'This is a demo of the Custom Coach Mark package',
            alignment: CoachMarkAlignment.bottom,
            backgroundColor: Colors.blue,
          ),
        ),
        CoachMarkTarget(
          key: _cardKey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.all(8),
          description: CoachMarkDesc(
            title: 'Featured Item',
            content: 'This card shows important information about the item',
            alignment: CoachMarkAlignment.top,
            backgroundColor: Colors.orange,
          ),
        ),
        CoachMarkTarget(
          key: _menuKey,
          shape: const CircleBorder(),
          description: CoachMarkDesc(
            title: 'Menu',
            content: 'Access app settings and more options',
            alignment: CoachMarkAlignment.bottomLeft,
            backgroundColor: Colors.green,
          ),
        ),
        CoachMarkTarget(
          key: _buttonKey,
          shape: const CircleBorder(),
          description: CoachMarkDesc(
            title: 'Add Item',
            content: 'Tap here to add a new item to your collection',
            alignment: CoachMarkAlignment.topRight,
            backgroundColor: Colors.purple,
          ),
        ),
      ],
      onFinish: () {
        setState(() {
          _tutorialShown = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tutorial completed!')),
        );
      },
      onSkip: () {
        setState(() {
          _tutorialShown = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tutorial skipped')),
        );
      },
    );
    
    // Show the coach mark after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.show(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomCoachMark(
      controller: _controller,
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Custom Coach Mark Demo',
            key: _titleKey,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              key: _menuKey,
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                key: _cardKey,
                margin: const EdgeInsets.all(16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 48, color: Colors.amber),
                      const SizedBox(height: 16),
                      const Text(
                        'Featured Item',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is a sample item to demonstrate the coach mark',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_tutorialShown)
                ElevatedButton(
                  onPressed: () {
                    _controller.show(context);
                  },
                  child: const Text('Restart Tutorial'),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: _buttonKey,
          onPressed: () {},
          tooltip: 'Add Item',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
