import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  String _diseaseLabel = "";
  double _confidence = 0.0;
  bool _isLoading = false;
  String? _errorMessage; // Variable to store error message

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    await _sendImageForDetection(pickedImage.path);
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    await _sendImageForDetection(pickedImage.path);
  }

  Future<void> _sendImageForDetection(String imagePath) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://13.49.244.142:8000/predict'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String label = data['class'] ?? 'Unknown';
        final double confidence = data['confidence']?.toDouble() ?? 0.0;

        setState(() {
          _diseaseLabel = label;
          _confidence = confidence * 100;
        });
      } else {
        // Enhanced Error Handling
        print('Error: ${response.statusCode} - ${response.body}');

        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          _errorMessage = errorData['error'] ?? 'Unknown error';
        } catch (e) {
          _errorMessage = response.reasonPhrase ?? 'Unknown error';
        }

        setState(() {
          _diseaseLabel = "Error";
          _confidence = 0.0;
        });
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _diseaseLabel = "Exception: $e";
        _confidence = 0.0;
        _errorMessage = "An error occurred during processing.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/bg.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rice Disease\nDetection App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 300,
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Please select an image",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                _isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Label:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                _diseaseLabel,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Confidence",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                "${_confidence.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white60,
                      ),
                      child: IconButton(
                        onPressed: _pickImageFromCamera,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black45,
                        ),
                        iconSize: 30.0,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white60,
                      ),
                      child: IconButton(
                        onPressed: _pickImageFromGallery,
                        icon: Icon(
                          Icons.image,
                          color: Colors.black45,
                        ),
                        iconSize: 30.0,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
