import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_recording/video_preview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  late CameraController _cameraController;
  bool _isRecording = false;

  @override
  void initState() {
    _initializeCameras();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CameraPreview(_cameraController),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: IconButton(
                      // backgroundColor: Colors.red,
                      icon: Column(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_isRecording)
                                Text(
                                  'REC',
                                  style: TextStyle(color: Colors.white),
                                ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.red,
                                )),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),

                      onPressed: () => _recordVideo(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _initializeCameras() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPreviewPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }
}
