## 1.0.2

* Replaced deprecated `Color.red`, `Color.green`, `Color.blue`, and `Color.alpha` getters with modern `.r`, `.g`, `.b`, and `.a` color channels for 100% pub.dev score compatibility.
* Formatted all source files with `dart format`.

## 1.0.1

* Updated documentation and cleaned up internal package metadata.

## 1.0.0

* Initial release of the `ghost_font` package.
* Added `GhostFont` widget with customizable noise animation speed, noise scale, colors, and font styling.
* Implemented hardware-accelerated dual-layer noise masking using `CustomPainter` and `BlendMode.srcIn`.
* Added interactive demo application in `example/`.
