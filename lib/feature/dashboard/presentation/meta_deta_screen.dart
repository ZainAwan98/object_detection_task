import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:object_detection/helper/routes_helper.dart';
import 'package:object_detection/routes/routes_names.dart';

class MetadataScreen extends StatelessWidget {
  final String imagePath;
  final String detectedClass;
  final String metadata;
  final String fileType;

  const MetadataScreen({
    super.key,
    required this.imagePath,
    required this.detectedClass,
    required this.metadata,
    required this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
      onWillPop: () async {
        RouteHelper.navigateAndRemoveUntil(
          context,
          RouteNames.onboardingView,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, size: 20.w),
                onPressed: () {
                  RouteHelper.navigateAndRemoveUntil(
                    context,
                    RouteNames.onboardingView,
                  );
                },
              ),
              SizedBox(width: 10.w),
              Text(
                "Detection Result",
                style: TextStyle(
                  fontSize: isPortrait ? 18.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10.w),
              child:
                  isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 0.6.sh,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20.h),
        _buildInfoSection(),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 0.7.sh,
            padding: EdgeInsets.only(right: 10.w),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildInfoSection(),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem("File Type:", fileType),
        _buildInfoItem("Detected Item:", detectedClass),
        _buildInfoItem("Time and Date:", metadata),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[800],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
