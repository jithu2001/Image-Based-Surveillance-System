import 'package:flutter/material.dart';

class ImageFromUrl extends StatefulWidget {
  final String imageUrl;

  const ImageFromUrl({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImageFromUrlState createState() => _ImageFromUrlState();
}

class _ImageFromUrlState extends State<ImageFromUrl> {
  late String _imageUrl;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
    _isLoading = true;
  }

  Future<void> _reloadImage() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay to show the loading indicator
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _imageUrl += '?timestamp=${DateTime.now().millisecondsSinceEpoch}';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Image'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              _imageUrl,
              loadingBuilder: (context, child, progress) {
                return progress == null ? child : CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadImage,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
