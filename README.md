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



## Getting Started

### Prerequisites
- Flutter SDK (v3.0+)
- Android/iOS development environment
- Physical mobile device 
