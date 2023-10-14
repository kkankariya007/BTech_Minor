import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;


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

Future upload() async{

  try {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://anizam.up.railway.app/name/"));
    // var audio = await http.MultipartFile.fromBytes('file',
    //     await File.fromUri(Uri.parse("/storage/emulated/0/Download/Anizam/temp.wav")).readAsBytes(),
        filename: 'temp.wav',
        contentType: MediaType.parse('audio/wav')//'audio', 'wav')
    );

    request.files.add(audio);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);

    String predict=result.toString();
    int idx=predict.indexOf('":"');
    charac=predict.substring(2,idx);
    anime=predict.substring(idx+3,predict.length-2);

  }
  catch(e)
  {
    // print(e);
  }
  // _hasp=true;

}
