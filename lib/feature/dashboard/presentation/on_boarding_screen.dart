import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:object_detection/feature/dashboard/application/selection_provider.dart';
import 'package:object_detection/feature/dashboard/presentation/object_detection_screen.dart';
import 'package:object_detection/utils/image_util.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<Map<String, String>> items = [
    {'name': 'Laptop', 'image': Images.laptopImage},
    {'name': 'Bottle', 'image': Images.bottleImage},
    {'name': 'Cell Phone', 'image': Images.phoneImage},
    {'name': 'Clock', 'image': Images.watchImage},
  ];

  void _navigateToNextScreen(BuildContext context) async {
    final cameras = await availableCameras();
    final provider = Provider.of<SelectionProvider>(context, listen: false);
    if (provider.selectedIndex != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectDetectionScreen(
            cameras: cameras,
            selectedItemName: items[provider.selectedIndex!]['name']!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an item"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelectionProvider>(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Select an Item"))),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 2 : 3,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: isPortrait ? 1 : 1.2,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    provider.selectedIndex = index;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: provider.selectedIndex == index
                            ? Colors.blue
                            : Colors.grey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(items[index]['image']!,
                            height: MediaQuery.of(context).size.height * 0.12),
                        SizedBox(height: 10.h),
                        Text(items[index]['name']!,
                            style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton(
              onPressed: () => _navigateToNextScreen(context),
              child: const Text("Get Started"),
            ),
          ),
        ],
      ),
    );
  }
}
