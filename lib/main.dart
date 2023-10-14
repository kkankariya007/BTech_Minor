import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {

  runApp(MaterialApp(
    home:CameraScreen(),
  ));
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _image;

  Future<void> _captureImage() async {
    final PickedFile? image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Early Crop Disease Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: _captureImage,
              child: Text('Take a Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
