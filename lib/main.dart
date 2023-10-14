import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

String predict="";
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

  Future upload() async{

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://disease.up.railway.app/upload"),
      );

      var imageFile = File(_image!.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // This should match the field name expected by the server
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // Change to 'image', 'jpg' or 'image', 'png' if needed
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);

      predict=result.toString();
      print(predict);
      // int idx=predict.indexOf('":"');
      // String charac=predict.substring(2,idx);
      // String anime=predict.substring(idx+3,predict.length-2);

    }
    catch(e)
    {
      print(e);
    }
    // _hasp=true;

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
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context){
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                  await upload();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Predict()));

                },
            child: Text('Predict')
            ),
          ],
        ),
      ),
    );
  }
}


class Predict extends StatefulWidget {
  const Predict({Key? key}) : super(key: key);

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        title: const Text('Early Crop Disease Detection'),
      ),
      body:
      Center(child: Text(predict.substring(1,predict.length-3),
      style: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      color: predict.substring(1,predict.length-3)=="Infected"?Colors.red:Colors.green,
      ),
      ),
    ),
    );
  }
}