# nprogress_flutter

A slim, smooth, and highly customizable top progress bar for Flutter applications.

Inspired by [NProgress](https://ricostacruz.com/nprogress/) by Rico Sta. Cruz (as seen on YouTube, Medium, and GitHub).

[![pub package](https://img.shields.io/pub/v/nprogress_flutter.svg)](https://pub.dev/packages/nprogress_flutter)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 🌟 Features

- ⚡ **Familiar & Simple API**: `NProgress.start()`, `NProgress.set(0.4)`, `NProgress.inc()`, `NProgress.done()`, `NProgress.remove()`.
- 🎨 **Extremely Customizable**: Custom colors, gradients, height, position (top/bottom), curves, trickle rate, and glowing tip (peg) effect.
- 🚀 **Global App Integration**: Seamless `MaterialApp.builder` wrapper for instant app-wide progress overlay.
- 🧭 **Automatic Route Tracking**: Built-in `NProgressNavigatorObserver` triggers progress automatically during route transitions.
- ⏳ **Smart Trickling**: Realistically auto-increments progress while waiting for long-running async tasks.
- 🎯 **Scoped & Standalone Widgets**: Use global singleton or local `NProgressController` with `NProgressWidget`.

---

## 📦 Installation

Add `nprogress_flutter` to your `pubspec.yaml`:

```bash
flutter pub add nprogress_flutter
```

Or manually:

```yaml
dependencies:
  nprogress_flutter: ^0.0.1
```

Import it in your Dart code:

```dart
import 'package:nprogress_flutter/nprogress_flutter.dart';
```

---

## 🚀 Quick Start

### 1. Global Setup

Wrap your `MaterialApp` using `NProgress.builder()` and optionally add `NProgressNavigatorObserver()`:

```dart
import 'package:flutter/material.dart';
import 'package:nprogress_flutter/nprogress_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NProgress Demo',
      // Attach NProgress overlay globally
      builder: NProgress.builder(),
      // Optional: Auto-trigger progress on route navigation
      navigatorObservers: [
        NProgressNavigatorObserver(),
      ],
      home: const HomePage(),
    );
  }
}
```

### 2. Controlling Progress

Control the progress bar from anywhere in your app using static calls to `NProgress`:

```dart
// Start the progress bar (starts at minimum value and trickles)
NProgress.start();

// Set progress to a specific value between 0.0 and 1.0
NProgress.set(0.4);

// Increment progress by a random amount or specific delta
NProgress.inc();
NProgress.inc(0.2);

// Complete the progress bar (animates to 100% and gracefully fades out)
NProgress.done();

// Immediately stop and hide without finishing animation
NProgress.remove();

// Check status
bool active = NProgress.isStarted;
double? current = NProgress.status;
```

---

## 🔄 Simulating Async Network Operations

You can easily tie `NProgress` to HTTP requests or long-running computations:

```dart
Future<void> fetchData() async {
  NProgress.start();
  try {
    final response = await http.get(Uri.parse('https://api.example.com/data'));
    // Do something with response...
  } finally {
    NProgress.done();
  }
}
```

---

## 🎨 Customization Options

Customize the bar appearance and behavior globally using `NProgress.configure(...)`:

```dart
NProgress.configure(
  NProgressOptions(
    color: const Color(0xFF2997FF), // Primary bar & spinner color
    gradient: const LinearGradient(  // Optional gradient override
      colors: [Colors.blue, Colors.cyanAccent],
    ),
    height: 3.0,                     // Bar height in pixels
    minimum: 0.08,                   // Minimum starting value
    speed: const Duration(milliseconds: 200), // Value animation duration
    trickle: true,                   // Auto-increment progress while active
    trickleSpeed: const Duration(milliseconds: 200), // Trickle tick interval
    showSpinner: true,               // Show spinning loader in top corner
    showPeg: true,                   // Show glowing head shadow effect
    position: NProgressPosition.top, // top or bottom
  ),
);
```

---

## 🎛️ Scoped Controllers & Local Widgets

If you prefer not to use the global singleton state, instantiate an independent `NProgressController`:

```dart
final controller = NProgressController();

// Use inside custom widget trees
NProgressWidget(controller: controller)

// Imperative control
controller.start();
controller.set(0.5);
controller.done();
```

---

## 📜 API Reference

### `NProgress` Static Facade

| Method / Property | Description |
|---|---|
| `NProgress.start({bool reset})` | Starts the progress bar and trickles. |
| `NProgress.set(double n)` | Sets progress to specific percentage (`0.0` - `1.0`). |
| `NProgress.inc([double? amount])` | Increments progress. |
| `NProgress.done({bool force})` | Completes progress to `1.0` and fades out. |
| `NProgress.remove()` | Immediately removes progress bar without fading. |
| `NProgress.configure(NProgressOptions)` | Configures options. |
| `NProgress.isStarted` | Returns `true` if active. |
| `NProgress.status` | Current double progress value or `null`. |
| `NProgress.builder()` | Returns a `MaterialApp.builder` widget wrapper. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
