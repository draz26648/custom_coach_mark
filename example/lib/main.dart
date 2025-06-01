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
        // Default style with minor customizations
        CoachMarkTarget(
          key: _titleKey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          description: CoachMarkDesc(
            title: 'Default Style',
            content: 'This uses the default style with purple background',
            alignment: CoachMarkAlignment.bottom,
            backgroundColor: Colors.purple,
            borderRadius: BorderRadius.circular(12),
            maxWidth: 300,
          ),
        ),
        
        // Custom decoration style
        CoachMarkTarget(
          key: _cardKey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          description: CoachMarkDesc(
            title: 'Custom Decoration',
            content: 'This uses a custom decoration with gradient background',
            alignment: CoachMarkAlignment.top,
            tooltipDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
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
            contentPadding: EdgeInsets.all(20),
            arrowSize: 15,
          ),
        ),
        
        // Custom button builders
        CoachMarkTarget(
          key: _menuKey,
          shape: const CircleBorder(),
          description: CoachMarkDesc(
            title: 'Custom Buttons',
            content: 'This example uses custom buttons and pagination indicators',
            alignment: CoachMarkAlignment.bottomLeft,
            backgroundColor: Colors.blue,
            skipButtonBuilder: (onSkip) => ElevatedButton(
              onPressed: onSkip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text('Exit'),
            ),
            nextButtonBuilder: (onNext, isLastStep) => ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: Text(isLastStep ? 'Finish' : 'Next'),
            ),
            previousButtonBuilder: (onPrevious) => TextButton(
              onPressed: onPrevious,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text('Back'),
            ),
            paginationBuilder: (currentIndex, totalCount) => Row(
              children: List.generate(
                totalCount,
                (index) => Container(
                  width: 12,
                  height: 12,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == currentIndex ? Colors.white : Colors.white30,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: index == currentIndex
                      ? Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
        
        // Completely custom tooltip using tooltipBuilder
        CoachMarkTarget(
          key: _buttonKey,
          shape: const CircleBorder(),
          description: CoachMarkDesc(
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
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: data.onSkip,
                        icon: Icon(Icons.close, color: Colors.red),
                        label: Text('SKIP', style: TextStyle(color: Colors.red)),
                      ),
                      Row(
                        children: [
                          if (data.hasPrevious)
                            IconButton(
                              onPressed: data.onPrevious,
                              icon: Icon(Icons.arrow_back, color: Colors.white),
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
                ],
              ),
            ),
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
