# object_detection

A Flutter-based mobile application for real-time object detection with guided positioning and automatic image capture.

## Features

- **4-Object Detection**: Identify laptops, bottles, cell phones, and clocks
- **Interactive Onboarding**: Visual selection of target detection objects
- **Smart Guidance System**: Real-time positioning feedback (move closer/away/left/right)
- **Auto-Capture**: Automatic image capture when optimal position is achieved
- **Metadata Display**: Shows detection results with timestamp and file information
- **Responsive UI**: Works seamlessly in both portrait and landscape orientations
- **Visual Feedback**: Color-coded instructions and guidance icons

## Application Flow

### 1. Onboarding Screen
- **Object Selection**: 
  - Choose from 4 detectable objects (laptop, bottle, cell phone, clock)
  - Visual buttons with object icons
  - "Get Started" button to begin detection

### 2. Object Detection Screen
- **Camera Interface**:
  - Back camera live feed
  - Dynamic positioning guidance overlay
  - Real-time object recognition
  - Automatic capture when:
    - Selected object is detected
    - Optimal positioning is maintained for 1 second

- **Guidance Messages**:
  - "Move closer" (object too small in frame)
  - "Move away" (object too large in frame)
  - "Move left/right" (object not centered)
  - "Perfect! Hold position..." (capture imminent)

### 3. Metadata Screen
- **Detection Results**:
  - Full-screen captured image
  - Detected object type
  - File format information (JPEG/PNG)
  - Timestamp of detection
  - Navigation back to onboarding

  ### Core Technologies
- **Flutter Framework**: Cross-platform UI development
- **TensorFlow Lite**: Object detection model (SSD MobileNet)
- **Camera Package**: Real-time camera feed processing
- **Provider**: State management across screens
- **ScreenUtil**: Responsive layout adaptations

### Key Features
- **Auto-Capture Logic**: 
  
  - Positional checks (centering, size requirements)
  - 1-second stabilization timer
  
- **Image Processing**:
  - Automatic file type detection
  - EXIF metadata preservation
  - Orientation-aware display

### Challenges Faced and Solutions Implemented

1. Object Detection Accuracy Across Different Orientations

- Challenge: The application struggled with accurate object detection, especially when the device was rotated between portrait and landscape modes. In landscape mode, objects like laptops were sometimes misidentified (e.g., detected as a TV).
Solution: The solution involved dynamically adjusting the aspect ratio and rotation parameters during image processing. I modified the processImage method to account for the device's orientation and the sensor's orientation. By correctly adjusting the rotation during detection, I was able to achieve accurate results across different orientations.
2. Managing Camera Preview and Object Detection Responsiveness

- Challenge: Maintaining a responsive camera preview and fast object detection while managing the UI layout was challenging. The camera feed needed to be displayed seamlessly while processing the real-time object detection without noticeable lag.
Solution: I optimized the image processing by ensuring that detection was done only when the camera feed was initialized and ready. Additionally, I used Flutter's Provider for efficient state management, allowing smooth updates of the UI and object detection without blocking the UI thread. I also made use of AspectRatio and Transform widgets to ensure the camera preview remains responsive in both portrait and landscape modes.

3. Responsive UI Across Different Screen Sizes and Orientations

- Challenge: Ensuring the app's UI was responsive across different screen sizes and orientations was a  significant challenge. The camera feed and object detection guidance had to adjust dynamically based on whether the device was in portrait or landscape mode.
Solution: I utilized the ScreenUtil package to ensure that UI elements were properly scaled for different screen sizes. The camera preview and bounding boxes were adjusted dynamically using aspect ratios, and conditional UI layouts were implemented to handle both portrait and landscape orientations. This made the app responsive on various devices while keeping the user experience consistent.
4. Automatic Image Capture Based on Positioning

- Challenge: Automatically capturing an image when the object was in the optimal position (centered, with the right size) required precise timing and positional checks, which was tricky to implement.
Solution: I implemented a stabilization timer that activated once the object was correctly centered and within the right size range. Using this logic, I ensured that images were only captured when the object remained in the optimal position for at least 1 second, which helped prevent unnecessary captures and improved the accuracy of the detected objects.


## Getting Started

### Prerequisites
- Flutter SDK (v3.0+)
- Android/iOS development environment
- Physical mobile device 
