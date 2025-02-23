import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ObjectDetectionProvider with ChangeNotifier {
  final List<CameraDescription> cameras;
  final String selectedItemName;
  late CameraController cameraController;
  bool isModelLoaded = false;
  List<dynamic>? detectedObjects;
  String guidanceMessage = "Align the object within the camera view";
  int orientation = 0;
  bool isCapturing = false;
  DateTime? lastGoodPositionTime;
  Function(String detectedClass, String imagePath)? onNavigate;

  ObjectDetectionProvider({
    required this.cameras,
    required this.selectedItemName,
  });

  Future<void> loadModel() async {
    String? result = await Tflite.loadModel(
      model: 'assets/models/detect.tflite',
      labels: 'assets/models/labelmap.txt',
    );
    isModelLoaded = result != null;
    notifyListeners();
  }

  Future<void> initializeCamera() async {
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize();
    orientation = cameraController.description.sensorOrientation;

    cameraController.startImageStream((image) {
      if (isModelLoaded && !isCapturing) processImage(image);
    });
    notifyListeners();
  }

  Future<void> processImage(CameraImage image) async {
    final objects = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      model: 'SSDMobileNet',
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.65,
      numResultsPerClass: 1,
    );

    final filtered = _filterDetections(objects);

    detectedObjects = filtered;
    guidanceMessage = _getUserGuidance(filtered);
    notifyListeners();

    if (filtered?.isNotEmpty ?? false) _handleGoodPosition(filtered!.first);
  }

  List<dynamic>? _filterDetections(List<dynamic>? detections) {
    if (detections == null) return null;
    detections.sort(
        (a, b) => b["confidenceInClass"].compareTo(a["confidenceInClass"]));
    return detections.take(1).toList();
  }

  Future<void> _handleGoodPosition(dynamic detection) async {
    final detectedClass = detection["detectedClass"].toString().toUpperCase();
    if (detectedClass != selectedItemName.toUpperCase()) return;

    if (lastGoodPositionTime == null) {
      lastGoodPositionTime = DateTime.now();
    } else if (DateTime.now().difference(lastGoodPositionTime!).inSeconds >=
        1) {
      isCapturing = true;
      lastGoodPositionTime = null;
      final imageFile = await cameraController.takePicture();
      onNavigate?.call(detectedClass, imageFile.path);
    }
  }

  String _getUserGuidance(List<dynamic>? objects) {
    if (objects == null || objects.isEmpty) {
      lastGoodPositionTime = null;
      return "Searching for $selectedItemName...";
    }

    final detection = objects.first;
    final rect = detection["rect"];
    final detectedClass = detection["detectedClass"].toString().toUpperCase();
    final targetClass = selectedItemName.toUpperCase();

    if (detectedClass != targetClass) {
      lastGoodPositionTime = null;
      return "Found $detectedClass - Keep searching";
    }

    final centerX = rect["x"] + rect["w"] / 2;
    final areaPercentage = rect["w"] * rect["h"];
    String message = "Perfect! Hold position...";
    bool isPerfect = true;

    if (areaPercentage < 0.25) {
      message = "Move closer";
      isPerfect = false;
    } else if (areaPercentage > 0.65) {
      message = "Move away";
      isPerfect = false;
    }

    if (centerX < 0.4) {
      message = "Move right";
      isPerfect = false;
    } else if (centerX > 0.6) {
      message = "Move left";
      isPerfect = false;
    }

    if (!isPerfect) lastGoodPositionTime = null;
    return message;
  }

  String getFileType(List<int> bytes) {
    if (bytes.length < 4) return 'Unknown';

    final header = bytes.sublist(0, 4);
    final hexHeader =
        header.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    switch (hexHeader) {
      case 'ffd8ffe0':
      case 'ffd8ffe1':
      case 'ffd8ffe2':
        return 'JPEG';
      case '89504e47':
        return 'PNG';
      case '47494638':
        return 'GIF';
      default:
        return 'Unknown';
    }
  }

  Future<void> stopCamera() async {
    if (cameraController.value.isStreamingImages) {
      await cameraController.stopImageStream();
    }
    await cameraController.dispose();
  }

  @override
  void dispose() {
    if (cameraController.value.isInitialized) {
      cameraController.dispose();
    }
    super.dispose();
  }
}
