# ghost_font

[![pub package](https://img.shields.io/pub/v/ghost_font.svg)](https://pub.dev/packages/ghost_font)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Android | iOS | Web | macOS | Windows | Linux](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue.svg)](https://pub.dev/packages/ghost_font)

A Flutter package that creates the viral **Ghost Font** effect. 

Ghost Font is an optical illusion typography widget where text is rendered entirely out of moving dual-layer noise static. Because human visual perception relies heavily on motion detection, the text is clear and readable while animated. However, the instant a user takes a static screenshot or freezes a frame, the text becomes 100% invisible and camouflages perfectly into random background noise!

---

## 🚀 Features

- 📸 **Screenshot Proof Security:** Text is impossible to capture in static screenshots or single frame grabs.
- 🎨 **Fully Customizable:** Easily adjust noise scale (dot size), animation speed, text styling, and custom background/pattern color combinations.
- ⚡ **High Performance & Seamless Tiling:** Uses hardware-accelerated dual-layer `CustomPainter` rendering with `ImageShader` and seamless noise texture generation.
- 📱 **Cross-Platform:** Works out-of-the-box on Android, iOS, Web, macOS, Windows, and Linux.
- 🧩 **Zero External Dependencies:** Built entirely with native Flutter canvas and shader capabilities.

---

## ⚡ Quickstart

Add `ghost_font` to your `pubspec.yaml` file:

```yaml
dependencies:
  ghost_font: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 💻 Usage

Import `package:ghost_font/ghost_font.dart` and drop `GhostFont` anywhere in your widget tree:

```dart
import 'package:flutter/material.dart';
import 'package:ghost_font/ghost_font.dart';

class SecretTextWidget extends StatelessWidget {
  const SecretTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.white,
      child: const GhostFont(
        text: 'CONFIDENTIAL',
        fontSize: 48,
        patternColor: Colors.black, // Color of moving noise dots
        backgroundColor: Colors.white, // Background noise color
        speed: 50.0, // Animation speed
        noiseScale: 2.0, // Scale/size of noise dots
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
```

---

## ⚙️ Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `text` | `String` | **Required** | The secret text string to display. |
| `fontSize` | `double` | `48.0` | Font size of the text. |
| `patternColor` | `Color` | `Colors.black` | Primary color for moving noise dots. |
| `backgroundColor` | `Color` | `Colors.white` | Secondary color for the noise canvas. |
| `speed` | `double` | `50.0` | Movement speed of the noise animation. |
| `noiseScale` | `double` | `2.0` | Scale of noise pixels (higher values make chunkier dots). |
| `fontWeight` | `FontWeight` | `FontWeight.bold` | Font weight applied to the text mask. |
| `noiseTextureSize` | `int` | `256` | Size in pixels of the seamless tileable noise texture. |

---

## 🔬 How It Works

This widget operates on principles of Gestalt visual motion perception:

1. **Dual Noise Layers**: Generates two identical, seamlessly tiled noise textures.
2. **Opposite Translational Motion**: The background noise layer moves continuously in one direction while the text foreground noise layer moves in the opposite direction.
3. **Alpha / Blend Masking**: The text shape masks the foreground noise using `BlendMode.srcIn`. 
4. **Perceptual Illusion**: In motion, the relative movement between the foreground and background creates sharp edge boundary perception in the human visual cortex. In a static frozen screenshot, both layers have identical pixel statistics, making the boundary 100% invisible.

---

## 📱 Demo Application

Check out the `example/` directory for a complete interactive sample app demonstrating customizable controls.

To run the example:

```bash
cd example
flutter run
```

---

## 📦 How to Publish to pub.dev

```bash
# 1. Verify dry run
flutter pub publish --dry-run

# 2. Publish package
flutter pub publish
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ✍️ Author

Developed By **Shahzain Baloch**
