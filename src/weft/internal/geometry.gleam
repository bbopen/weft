//// Internal geometry helpers for weft's anchored overlay micro-solver.
////
//// These types and functions are `@internal` so only the `weft` package can
//// use them. The stable public API is exposed from `weft.gleam`.

/// An internal point in integer CSS pixels.
@internal
pub type Point {
  Point(x: Int, y: Int)
}

/// Construct a point.
@internal
pub fn point(x x: Int, y y: Int) -> Point {
  Point(x: x, y: y)
}

/// Get the x coordinate of a point.
@internal
pub fn point_x(point point: Point) -> Int {
  case point {
    Point(x:, ..) -> x
  }
}

/// Get the y coordinate of a point.
@internal
pub fn point_y(point point: Point) -> Int {
  case point {
    Point(y:, ..) -> y
  }
}

fn clamp_non_negative_int(value: Int) -> Int {
  case value < 0 {
    True -> 0
    False -> value
  }
}

/// An internal size in integer CSS pixels.
@internal
pub type Size {
  Size(width: Int, height: Int)
}

/// Construct a size.
///
/// Width/height are clamped to be non-negative.
@internal
pub fn size(width width: Int, height height: Int) -> Size {
  Size(
    width: clamp_non_negative_int(width),
    height: clamp_non_negative_int(height),
  )
}

/// Get the width of a size.
@internal
pub fn size_width(size size: Size) -> Int {
  case size {
    Size(width:, ..) -> width
  }
}

/// Get the height of a size.
@internal
pub fn size_height(size size: Size) -> Int {
  case size {
    Size(height:, ..) -> height
  }
}

/// An internal rectangle in integer CSS pixels.
@internal
pub type Rect {
  Rect(x: Int, y: Int, width: Int, height: Int)
}

/// Construct a rectangle.
///
/// Width/height are clamped to be non-negative. Positions may be negative.
@internal
pub fn rect(x x: Int, y y: Int, width width: Int, height height: Int) -> Rect {
  Rect(
    x: x,
    y: y,
    width: clamp_non_negative_int(width),
    height: clamp_non_negative_int(height),
  )
}

/// Get the x coordinate of a rect.
@internal
pub fn rect_x(rect rect: Rect) -> Int {
  case rect {
    Rect(x:, ..) -> x
  }
}

/// Get the y coordinate of a rect.
@internal
pub fn rect_y(rect rect: Rect) -> Int {
  case rect {
    Rect(y:, ..) -> y
  }
}

/// Get the width of a rect.
@internal
pub fn rect_width(rect rect: Rect) -> Int {
  case rect {
    Rect(width:, ..) -> width
  }
}

/// Get the height of a rect.
@internal
pub fn rect_height(rect rect: Rect) -> Int {
  case rect {
    Rect(height:, ..) -> height
  }
}

/// Get the right edge of a rect (x + width).
@internal
pub fn rect_right(rect rect: Rect) -> Int {
  rect_x(rect) + rect_width(rect)
}

/// Get the bottom edge of a rect (y + height).
@internal
pub fn rect_bottom(rect rect: Rect) -> Int {
  rect_y(rect) + rect_height(rect)
}

/// Get the x coordinate of the rect center (x + width/2).
@internal
pub fn rect_center_x(rect rect: Rect) -> Int {
  rect_x(rect) + rect_width(rect) / 2
}

/// Get the y coordinate of the rect center (y + height/2).
@internal
pub fn rect_center_y(rect rect: Rect) -> Int {
  rect_y(rect) + rect_height(rect) / 2
}

/// Inset a rectangle by the given edge offsets.
///
/// Width/height are clamped to be non-negative.
@internal
pub fn rect_inset(
  rect source: Rect,
  left left: Int,
  top top: Int,
  right right: Int,
  bottom bottom: Int,
) -> Rect {
  let x = rect_x(source) + left
  let y = rect_y(source) + top
  let width = rect_width(source) - left - right
  let height = rect_height(source) - top - bottom

  rect(x: x, y: y, width: width, height: height)
}
