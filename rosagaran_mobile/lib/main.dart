import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Entry point of the application
void main() {
  runApp(
    // Makes ThemeModel available throughout the app
    ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current theme state from Provider
    final themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Change the app theme depending on the Provider state
      theme: themeModel.isDark
          ? ThemeData.dark()
          : ThemeData.light(),

      // Open the Counter (Ephemeral State) page first
      home: const MyHomePage(),
    );
  }
}

//=========================================================
//             EPHEMERAL STATE (setState)
//=========================================================

/// Counter page that demonstrates local (ephemeral) state
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Stores the current counter value
  int _counter = 0;

  /// Increases the counter by 1
  /// setState() tells Flutter to rebuild the UI
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Top app bar
      appBar: AppBar(
        title: const Text("Ephemeral State Example"),

        // Button that navigates to the App State page
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHome(),
                ),
              );
            },
            child: const Text(
              "App State",
              style: TextStyle(color: Color.fromARGB(255, 218, 70, 70)),
            ),
          ),
        ],
      ),

      // Main content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Instruction text
            const Text(
              "You have pushed the button this many times:",
            ),

            // Displays the current counter value
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      // Floating button to increase the counter
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}

//=========================================================
//             APP STATE (Provider)
//=========================================================

/// Stores the application's theme state
/// ChangeNotifier allows widgets to be notified
/// whenever the theme changes.
class ThemeModel with ChangeNotifier {

  // Current theme (false = Light, true = Dark)
  bool _isDark = false;

  // Read-only access to the theme value
  bool get isDark => _isDark;

  /// Switch between Light and Dark themes
  void toggleTheme() {

    // Change the value
    _isDark = !_isDark;

    // Notify all listening widgets to rebuild
    notifyListeners();
  }
}

/// Page demonstrating App State using Provider
class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {

    // Get the ThemeModel from Provider
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("App State Example"),
      ),

      body: Center(

        // Switch to change between Light and Dark mode
        child: SwitchListTile(
          title: const Text("Dark Mode"),

          // Current switch value
          value: themeModel.isDark,

          // Toggle the theme when the switch changes
          onChanged: (_) {
            themeModel.toggleTheme();
          },
        ),
      ),
    );
  }
}