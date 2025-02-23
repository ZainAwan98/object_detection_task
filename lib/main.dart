import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:object_detection/feature/dashboard/application/object_detection_provider.dart';
import 'package:object_detection/feature/dashboard/application/selection_provider.dart';
import 'package:object_detection/feature/dashboard/presentation/on_boarding_screen.dart';
import 'package:object_detection/routes/routes_generator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                ObjectDetectionProvider(cameras: [], selectedItemName: '')),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: OnboardingScreen(),
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
