import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:imss_app/image2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final databaseReference = FirebaseDatabase.instance.reference();

  void lock() {
    databaseReference.set(1);
  }

  void unlock() {
    databaseReference.set(0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lock/Unlock',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageFromUrl(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/image-9369d.appspot.com/o/face.jpg?alt=media&token=5e5f555d-8290-40da-a803-4893bb41d29d',
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.camera_enhance_rounded,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ],
          title: const Text('Lock/Unlock'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedLockButton(
                onPressed: lock,
                label: 'Lock',
                lockedColor: Colors.red,
                unlockedColor: Colors.green,
              ),
              SizedBox(height: 16),
              AnimatedLockButton(
                onPressed: unlock,
                label: 'Unlock',
                lockedColor: Colors.green,
                unlockedColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLockButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color lockedColor;
  final Color unlockedColor;

  AnimatedLockButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.lockedColor,
    required this.unlockedColor,
  }) : super(key: key);

  @override
  _AnimatedLockButtonState createState() => _AnimatedLockButtonState();
}

class _AnimatedLockButtonState extends State<AnimatedLockButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..addListener(() {
      setState(() {});
    });

  late final Animation<Color?> _colorAnimation =
      ColorTween(begin: widget.lockedColor, end: widget.unlockedColor)
          .animate(_controller);

  bool _isLocked = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isLocked = !_isLocked;
        });
        widget.onPressed();
        _controller.forward(from: 0);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isLocked ? Icons.lock : Icons.lock_open,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: _colorAnimation.value,
        onPrimary: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
