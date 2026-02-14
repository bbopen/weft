//// Elm-UI-inspired layout primitives on top of Sketch — core package (Lustre-free).
////
//// `weft` provides a small, typed layout attribute DSL that compiles to
//// `sketch/css.Class`. It is renderer-agnostic: adapters (for example
//// `weft_lustre`) turn classes into concrete UI elements.
////
//// This module is intentionally conservative: it exposes layout primitives,
//// not raw CSS escape hatches.

import gleam/int
import gleam/list
import sketch/css

/// A sizing value inspired by Elm-UI.
pub type Length {
  Fill
  Shrink
  FillPortion(Int)
  Px(Int)
  Minimum(Length, Length)
}

/// Fill the available space.
pub fn fill() -> Length {
  Fill
}

/// Take only the required space.
pub fn shrink() -> Length {
  Shrink
}

/// Fill space proportionally to other filled siblings.
pub fn fill_portion(portion: Int) -> Length {
  FillPortion(portion)
}

/// A fixed pixel length.
pub fn px(pixels: Int) -> Length {
  Px(pixels)
}

/// Combine a base length with a minimum constraint.
pub fn minimum(base: Length, min: Length) -> Length {
  Minimum(base, min)
}

/// A typed RGB color.
pub type Color {
  Rgb(red: Int, green: Int, blue: Int)
}

/// Construct an RGB color.
pub fn rgb(red: Int, green: Int, blue: Int) -> Color {
  Rgb(red: red, green: green, blue: blue)
}

/// A typed, safe set of layout and style attributes.
pub opaque type Attribute {
  Attribute(styles: List(css.Style))
}

fn attr(styles: List(css.Style)) -> Attribute {
  Attribute(styles: styles)
}

fn px_value(pixels: Int) -> String {
  int.to_string(pixels) <> "px"
}

fn rgb_value(color: Color) -> String {
  case color {
    Rgb(red:, green:, blue:) ->
      "rgb("
      <> int.to_string(red)
      <> ", "
      <> int.to_string(green)
      <> ", "
      <> int.to_string(blue)
      <> ")"
  }
}

/// The base layout rules for a row container.
pub fn row_layout() -> Attribute {
  attr([
    css.property("display", "flex"),
    css.property("flex-direction", "row"),
    css.property("box-sizing", "border-box"),
    css.property("min-width", "0"),
  ])
}

/// The base layout rules for a column container.
pub fn column_layout() -> Attribute {
  attr([
    css.property("display", "flex"),
    css.property("flex-direction", "column"),
    css.property("box-sizing", "border-box"),
    css.property("min-width", "0"),
  ])
}

/// The base layout rules for a generic element container.
pub fn el_layout() -> Attribute {
  attr([
    css.property("box-sizing", "border-box"),
    css.property("min-width", "0"),
  ])
}

/// Set the gap (spacing) between children in a layout container.
pub fn spacing(pixels: Int) -> Attribute {
  attr([css.property("gap", px_value(pixels))])
}

/// Set uniform padding.
pub fn padding(pixels: Int) -> Attribute {
  attr([css.property("padding", px_value(pixels))])
}

/// Set padding with separate x (left/right) and y (top/bottom) values.
pub fn padding_xy(x: Int, y: Int) -> Attribute {
  attr([css.property("padding", px_value(y) <> " " <> px_value(x))])
}

/// Center an element horizontally within its container.
pub fn center_x() -> Attribute {
  attr([
    css.property("margin-left", "auto"),
    css.property("margin-right", "auto"),
  ])
}

/// Center an element vertically within its container.
pub fn center_y() -> Attribute {
  attr([
    css.property("margin-top", "auto"),
    css.property("margin-bottom", "auto"),
  ])
}

/// Align an element to the left within its container.
pub fn align_left() -> Attribute {
  attr([
    css.property("margin-left", "0"),
    css.property("margin-right", "auto"),
  ])
}

/// Align an element to the right within its container.
pub fn align_right() -> Attribute {
  attr([
    css.property("margin-left", "auto"),
    css.property("margin-right", "0"),
  ])
}

/// Align an element to the top within its container.
pub fn align_top() -> Attribute {
  attr([
    css.property("margin-top", "0"),
    css.property("margin-bottom", "auto"),
  ])
}

/// Align an element to the bottom within its container.
pub fn align_bottom() -> Attribute {
  attr([
    css.property("margin-top", "auto"),
    css.property("margin-bottom", "0"),
  ])
}

/// Set the background color for an element.
pub fn background(color: Color) -> Attribute {
  attr([css.property("background-color", rgb_value(color))])
}

/// Set the text color for an element.
pub fn text_color(color: Color) -> Attribute {
  attr([css.property("color", rgb_value(color))])
}

fn width_properties(length: Length) -> List(css.Style) {
  case length {
    Fill ->
      [
        css.property("flex-grow", "1"),
        css.property("flex-basis", "0"),
      ]

    Shrink ->
      [
        css.property("flex-grow", "0"),
        css.property("flex-basis", "auto"),
      ]

    FillPortion(portion) ->
      [
        css.property("flex-grow", int.to_string(portion)),
        css.property("flex-basis", "0"),
      ]

    Px(pixels) ->
      [
        css.property("width", px_value(pixels)),
        css.property("flex-grow", "0"),
        css.property("flex-shrink", "0"),
      ]

    Minimum(base, min) -> {
      let base_props = width_properties(base)
      let min_props =
        case min {
          Px(pixels) -> [css.property("min-width", px_value(pixels))]
          _ -> []
        }
      list.append(base_props, min_props)
    }
  }
}

fn height_properties(length: Length) -> List(css.Style) {
  case length {
    Fill ->
      [
        css.property("flex-grow", "1"),
        css.property("flex-basis", "0"),
      ]

    Shrink ->
      [
        css.property("flex-grow", "0"),
        css.property("flex-basis", "auto"),
      ]

    FillPortion(portion) ->
      [
        css.property("flex-grow", int.to_string(portion)),
        css.property("flex-basis", "0"),
      ]

    Px(pixels) ->
      [
        css.property("height", px_value(pixels)),
        css.property("flex-grow", "0"),
        css.property("flex-shrink", "0"),
      ]

    Minimum(base, min) -> {
      let base_props = height_properties(base)
      let min_props =
        case min {
          Px(pixels) -> [css.property("min-height", px_value(pixels))]
          _ -> []
        }
      list.append(base_props, min_props)
    }
  }
}

/// Set an element's width using a `Length`.
pub fn width(length: Length) -> Attribute {
  attr(width_properties(length))
}

/// Set an element's height using a `Length`.
pub fn height(length: Length) -> Attribute {
  attr(height_properties(length))
}

/// Build a Sketch `css.Class` from a list of `Attribute`s.
pub fn class(attrs: List(Attribute)) -> css.Class {
  let styles =
    attrs
    |> list.flat_map(fn(attr) {
      case attr {
        Attribute(styles: styles) -> styles
      }
    })

  css.class(styles)
}
