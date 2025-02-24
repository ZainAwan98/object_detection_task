import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:object_detection/feature/dashboard/application/object_detection_provider.dart';
import 'package:object_detection/helper/routes_helper.dart';
import 'package:object_detection/routes/routes_names.dart';
import 'package:provider/provider.dart';

class ObjectDetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String selectedItemName;
  const ObjectDetectionScreen({
    super.key,
    required this.cameras,
    required this.selectedItemName,
  });

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  late ObjectDetectionProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ObjectDetectionProvider(
      cameras: widget.cameras,
      selectedItemName: widget.selectedItemName,
    );

    _provider.loadModel().then((_) => _provider.initializeCamera());

    _provider.onNavigate = _navigateToMetadataScreen;
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _navigateToMetadataScreen(String detectedClass, String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    String fileType = _provider.getFileType(bytes);

    RouteHelper.navigateTo(
      context,
      RouteNames.imageMetaDetaView,
      arguments: {
        'imagePath': imagePath,
        'fileType': fileType,
        'detectedClass': detectedClass,
        'metadata': "Detected at ${DateTime.now()}",
        'provider': _provider,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<ObjectDetectionProvider>(
        builder: (context, provider, child) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          if (provider.cameraController != null) {
            if (!provider.cameraController!.value.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }
          }

          return Scaffold(
            appBar: AppBar(
              title:
                  Center(child: Text('Detecting ${widget.selectedItemName}')),
            ),
            body: isPortrait
                ? Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Transform.rotate(
                              angle: provider.orientation * 3.1415927 / 180,
                              child: AspectRatio(
                                aspectRatio: provider.cameraController != null
                                    ? provider
                                        .cameraController!.value.aspectRatio
                                    : 16 / 9,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 4),
                                  ),
                                  child: provider.cameraController != null
                                      ? CameraPreview(
                                          provider.cameraController!)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          provider.guidanceMessage,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 0.3.sw,
                                    child: Transform.rotate(
                                      angle: provider.orientation *
                                          3.1415927 /
                                          180,
                                      child: AspectRatio(
                                        aspectRatio:
                                            provider.cameraController != null
                                                ? provider.cameraController!
                                                        .value.aspectRatio /
                                                    2
                                                : 16 / 9,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blue, width: 4),
                                          ),
                                          child: provider.cameraController !=
                                                  null
                                              ? CameraPreview(
                                                  provider.cameraController!)
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            provider.guidanceMessage,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class BoundingBoxes extends StatelessWidget {
  final List<dynamic> recognitions;
  final double previewH;
  final double previewW;
  final double screenH;
  final double screenW;

  const BoundingBoxes({
    super.key,
    required this.recognitions,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: recognitions.map((rec) {
        var x = rec["rect"]["x"] * screenW;
        var y = rec["rect"]["y"] * screenH;
        double w = rec["rect"]["w"] * screenW;
        double h = rec["rect"]["h"] * screenH;

        return Positioned(
          left: x,
          top: y,
          width: w,
          height: h,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3,
              ),
            ),
            child: Text(
              "${rec["detectedClass"]} ${(rec["confidenceInClass"] * 100).toStringAsFixed(0)}% Width:${(w).ceil()} Heght: ${h.ceil()}",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                background: Paint()..color = Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
