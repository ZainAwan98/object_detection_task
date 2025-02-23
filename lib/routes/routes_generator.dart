import 'package:flutter/material.dart';
import 'package:object_detection/feature/dashboard/presentation/meta_deta_screen.dart';
import 'package:object_detection/feature/dashboard/presentation/object_detection_screen.dart';
import 'package:object_detection/feature/dashboard/presentation/on_boarding_screen.dart';
import 'package:object_detection/routes/routes_names.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.onboardingView:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
        );
      case RouteNames.objectDetectionView:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => ObjectDetectionScreen(
            cameras: args['cameras'],
            selectedItemName: args['selectedItem'],
          ),
        );
      case RouteNames.imageMetaDetaView:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => MetadataScreen(
            imagePath: args['imagePath'],
            fileType: args['fileType'],
            detectedClass: args['detectedClass'],
            metadata: args['metadata'],
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found!")),
      ),
    );
  }
}
