import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  OverlayEntry entry;
  Offset offset = Offset(20, 40);

  void showOverlay() {
    if (entry == null) {
      initializeOverlayEntry();
    }

    final overlay = Overlay.of(context);
    overlay.insert(entry);
  }

  void hideOverlay() {
    if (entry != null) {
      entry.remove();
      entry = null;
    }
  }

  void onDragOverlay(DragUpdateDetails details) {
    offset += details.delta;
    entry.markNeedsBuild(); // Use this instead of setstate
  }

  void initializeOverlayEntry() {
    entry = OverlayEntry(
        builder: (_) => Positioned(
              left: offset.dx,
              top: offset.dy,
              child: GestureDetector(
                onPanUpdate: onDragOverlay,
                child: ElevatedButton.icon(
                  style: TextButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {},
                  icon: Icon(Icons.play_arrow),
                  label: Text(
                    "Play",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ));
  }

  Widget _buildButton({Function onPressed, IconData icon, String title}) => Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 48,
        margin: EdgeInsets.symmetric(vertical: 12),
        child: ElevatedButton.icon(
          style: TextButton.styleFrom(backgroundColor: Colors.amber),
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );

  @override
  void initState() {
    // Build the overlay before the process of building widgets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOverlay();
    });
    super.initState();
  }

  @override
  void dispose() {
    hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Overlay Demo"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(title: "Show Floating Widget", icon: Icons.visibility, onPressed: showOverlay),
            _buildButton(title: "Hide Floating Widget", icon: Icons.visibility_off, onPressed: hideOverlay)
          ],
        ),
      ),
    );
  }
}
