enum DotShape { circle, square, rectangle }
const double invalidSize = -1.0;

class Shape {
  Shape(
      {this.width, this.height, this.size, this.spacing, required this.shape}) {
    _throwAssertionErrorIfInvalidShape();
    _throwArgumentErrorIfMissingSizeArgumentForCircleOrSquareShape();
    _throwArgumentErrorIfMissingWidthOrHeightForRectangleShape();

    switch (shape) {
      case DotShape.circle:
      case DotShape.square:
        width = size;
        height = size;
        break;
      case DotShape.rectangle:
        size = invalidSize;
        break;
      default:
    }
  }

  void _throwAssertionErrorIfInvalidShape() {
    try {
      assert(shape != null, 'shape not null');
    } on AssertionError catch (assertionError) {
      throw AssertionError(assertionError.message);
    }
  }

  void _throwArgumentErrorIfMissingSizeArgumentForCircleOrSquareShape() {
    if (shape == DotShape.circle || shape == DotShape.square) {
      try {
        assert(size != null, 'shape not null');
      } on AssertionError catch (_) {
        throw ArgumentError('No size found for ${shape.toString()}');
      }
    }
  }

  void _throwArgumentErrorIfMissingWidthOrHeightForRectangleShape() {
    if (shape == DotShape.rectangle) {
      try {
        assert(width != null, 'shape not null');
        assert(height != null, 'shape not null');
      } on AssertionError catch (_) {
        throw ArgumentError('No size found for ${shape.toString()}');
      }
    }
  }

  double? width;
  double? height;
  double? size;
  final double? spacing;
  final DotShape? shape;

  static final defaultShape =
      Shape(size: 16.0, spacing: 8.0, shape: DotShape.circle);
}
