//// Elm-UI-inspired layout primitives that generate deterministic CSS.
////
//// `weft` is the core (renderer-agnostic) package. It provides:
//// - typed layout and styling constructors (`Attribute`)
//// - deterministic class compilation (`Class`)
//// - deterministic CSS rendering (`stylesheet`)
////
//// The public API intentionally exposes no raw CSS escape hatch: `Attribute`
//// is opaque and can only be created via the constructors in this module.

import gleam/float
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/string
import weft/internal/geometry
import weft/internal/overlay

/// A concrete CSS measurement (px, rem, %, viewport units).
pub opaque type CssLength {
  CssLength(value: String)
}

/// A layout sizing intent inspired by Elm-UI.
pub opaque type Length {
  Fill
  Shrink
  FillPortion(Int)
  Fixed(CssLength)
  Minimum(Length, CssLength)
  Maximum(Length, CssLength)
}

/// A typed CSS color.
pub opaque type Color {
  Color(value: String)
}

/// A single color stop in a gradient.
pub opaque type GradientStop {
  GradientStop(value: String)
}

/// A linear gradient value for use with `background_gradient`.
pub opaque type LinearGradient {
  LinearGradient(value: String)
}

/// A CSS duration (for example `150ms` or `0.2s`).
pub opaque type Duration {
  Duration(value: String)
}

/// A CSS timing function for transitions.
pub opaque type Easing {
  Easing(value: String)
}

/// A typed CSS transition property.
pub opaque type TransitionProperty {
  TransitionProperty(value: String)
}

/// A single transition entry (property, duration, easing, optional delay).
pub opaque type Transition {
  Transition(
    property: TransitionProperty,
    duration: Duration,
    easing: Easing,
    delay: Option(Duration),
  )
}

/// A CSS cursor value.
pub opaque type Cursor {
  Cursor(value: String)
}

/// A typed CSS `pointer-events` value.
pub opaque type PointerEvents {
  PointerEvents(value: String)
}

/// A point in integer CSS pixels (used by the anchored overlay micro-solver).
pub opaque type Point {
  Point(inner: geometry.Point)
}

/// A size in integer CSS pixels (used by the anchored overlay micro-solver).
pub opaque type Size {
  Size(inner: geometry.Size)
}

/// A rectangle in integer CSS pixels (used by the anchored overlay micro-solver).
pub opaque type Rect {
  Rect(inner: geometry.Rect)
}

/// The side of an overlay relative to its anchor.
pub opaque type OverlaySide {
  OverlaySide(inner: overlay.OverlaySide)
}

/// The alignment of an overlay on its cross-axis.
pub opaque type OverlayAlign {
  OverlayAlign(inner: overlay.OverlayAlign)
}

/// A placement (side + alignment).
pub opaque type OverlayPlacement {
  OverlayPlacement(inner: overlay.OverlayPlacement)
}

/// The input problem for anchored overlay solving.
pub opaque type OverlayProblem {
  OverlayProblem(inner: overlay.OverlayProblem)
}

/// The output solution for anchored overlay solving.
pub opaque type OverlaySolution {
  OverlaySolution(inner: overlay.OverlaySolution)
}

fn unwrap_point(point: Point) -> geometry.Point {
  case point {
    Point(inner:) -> inner
  }
}

fn wrap_point(point: geometry.Point) -> Point {
  Point(inner: point)
}

fn unwrap_size(size: Size) -> geometry.Size {
  case size {
    Size(inner:) -> inner
  }
}

fn wrap_size(size: geometry.Size) -> Size {
  Size(inner: size)
}

fn unwrap_rect(rect: Rect) -> geometry.Rect {
  case rect {
    Rect(inner:) -> inner
  }
}

fn wrap_rect(rect: geometry.Rect) -> Rect {
  Rect(inner: rect)
}

fn unwrap_side(side: OverlaySide) -> overlay.OverlaySide {
  case side {
    OverlaySide(inner:) -> inner
  }
}

fn wrap_side(side: overlay.OverlaySide) -> OverlaySide {
  OverlaySide(inner: side)
}

fn unwrap_align(align: OverlayAlign) -> overlay.OverlayAlign {
  case align {
    OverlayAlign(inner:) -> inner
  }
}

fn wrap_align(align: overlay.OverlayAlign) -> OverlayAlign {
  OverlayAlign(inner: align)
}

fn unwrap_placement(placement: OverlayPlacement) -> overlay.OverlayPlacement {
  case placement {
    OverlayPlacement(inner:) -> inner
  }
}

fn wrap_placement(placement: overlay.OverlayPlacement) -> OverlayPlacement {
  OverlayPlacement(inner: placement)
}

fn unwrap_problem(problem: OverlayProblem) -> overlay.OverlayProblem {
  case problem {
    OverlayProblem(inner:) -> inner
  }
}

fn wrap_problem(problem: overlay.OverlayProblem) -> OverlayProblem {
  OverlayProblem(inner: problem)
}

fn unwrap_solution(solution: OverlaySolution) -> overlay.OverlaySolution {
  case solution {
    OverlaySolution(inner:) -> inner
  }
}

fn wrap_solution(solution: overlay.OverlaySolution) -> OverlaySolution {
  OverlaySolution(inner: solution)
}

/// Construct a point.
pub fn point(x x: Int, y y: Int) -> Point {
  geometry.point(x: x, y: y) |> wrap_point
}

/// Get the x coordinate of a point.
pub fn point_x(point point: Point) -> Int {
  point |> unwrap_point |> geometry.point_x
}

/// Get the y coordinate of a point.
pub fn point_y(point point: Point) -> Int {
  point |> unwrap_point |> geometry.point_y
}

/// Construct a size.
///
/// Width/height are clamped to be non-negative.
pub fn size(width width: Int, height height: Int) -> Size {
  geometry.size(width: width, height: height) |> wrap_size
}

/// Get the width of a size.
pub fn size_width(size size: Size) -> Int {
  size |> unwrap_size |> geometry.size_width
}

/// Get the height of a size.
pub fn size_height(size size: Size) -> Int {
  size |> unwrap_size |> geometry.size_height
}

/// Construct a rectangle.
///
/// Width/height are clamped to be non-negative. Positions may be negative.
pub fn rect(x x: Int, y y: Int, width width: Int, height height: Int) -> Rect {
  geometry.rect(x: x, y: y, width: width, height: height) |> wrap_rect
}

/// Get the x coordinate of a rect.
pub fn rect_x(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_x
}

/// Get the y coordinate of a rect.
pub fn rect_y(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_y
}

/// Get the width of a rect.
pub fn rect_width(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_width
}

/// Get the height of a rect.
pub fn rect_height(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_height
}

/// Get the right edge of a rect (x + width).
pub fn rect_right(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_right
}

/// Get the bottom edge of a rect (y + height).
pub fn rect_bottom(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_bottom
}

/// Get the x coordinate of the rect center (x + width/2).
pub fn rect_center_x(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_center_x
}

/// Get the y coordinate of the rect center (y + height/2).
pub fn rect_center_y(rect rect: Rect) -> Int {
  rect |> unwrap_rect |> geometry.rect_center_y
}

/// Inset a rectangle by the given edge offsets.
///
/// Width/height are clamped to be non-negative.
pub fn rect_inset(
  rect rect: Rect,
  left left: Int,
  top top: Int,
  right right: Int,
  bottom bottom: Int,
) -> Rect {
  geometry.rect_inset(
    rect: unwrap_rect(rect),
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  )
  |> wrap_rect
}

/// Construct a side representing "above".
pub fn overlay_side_above() -> OverlaySide {
  overlay.overlay_side_above() |> wrap_side
}

/// Construct a side representing "below".
pub fn overlay_side_below() -> OverlaySide {
  overlay.overlay_side_below() |> wrap_side
}

/// Construct a side representing "left".
pub fn overlay_side_left() -> OverlaySide {
  overlay.overlay_side_left() |> wrap_side
}

/// Construct a side representing "right".
pub fn overlay_side_right() -> OverlaySide {
  overlay.overlay_side_right() |> wrap_side
}

/// Construct an alignment representing "start".
pub fn overlay_align_start() -> OverlayAlign {
  overlay.overlay_align_start() |> wrap_align
}

/// Construct an alignment representing "center".
pub fn overlay_align_center() -> OverlayAlign {
  overlay.overlay_align_center() |> wrap_align
}

/// Construct an alignment representing "end".
pub fn overlay_align_end() -> OverlayAlign {
  overlay.overlay_align_end() |> wrap_align
}

/// Construct a placement.
pub fn overlay_placement(
  side side: OverlaySide,
  align align: OverlayAlign,
) -> OverlayPlacement {
  overlay.overlay_placement(side: unwrap_side(side), align: unwrap_align(align))
  |> wrap_placement
}

/// Get the side of a placement.
pub fn overlay_placement_side(
  placement placement: OverlayPlacement,
) -> OverlaySide {
  placement |> unwrap_placement |> overlay.overlay_placement_side |> wrap_side
}

/// Get the alignment of a placement.
pub fn overlay_placement_align(
  placement placement: OverlayPlacement,
) -> OverlayAlign {
  placement
  |> unwrap_placement
  |> overlay.overlay_placement_align
  |> wrap_align
}

/// Construct a default overlay problem.
pub fn overlay_problem(
  anchor anchor: Rect,
  overlay overlay_size: Size,
  viewport viewport: Rect,
) -> OverlayProblem {
  overlay.overlay_problem(
    anchor: unwrap_rect(anchor),
    overlay: unwrap_size(overlay_size),
    viewport: unwrap_rect(viewport),
  )
  |> wrap_problem
}

/// Set the preferred side order for a problem.
///
/// Passing an empty list resets to the default order.
pub fn overlay_prefer_sides(
  problem problem: OverlayProblem,
  sides sides: List(OverlaySide),
) -> OverlayProblem {
  let sides = list.map(sides, unwrap_side)

  overlay.overlay_prefer_sides(problem: unwrap_problem(problem), sides: sides)
  |> wrap_problem
}

/// Set the allowed alignments for a problem.
///
/// Passing an empty list resets to the default order.
pub fn overlay_alignments(
  problem problem: OverlayProblem,
  aligns aligns: List(OverlayAlign),
) -> OverlayProblem {
  let aligns = list.map(aligns, unwrap_align)

  overlay.overlay_alignments(problem: unwrap_problem(problem), aligns: aligns)
  |> wrap_problem
}

/// Set the overlay-to-anchor offset in pixels.
///
/// Negative values are clamped to `0`.
pub fn overlay_offset(
  problem problem: OverlayProblem,
  pixels pixels: Int,
) -> OverlayProblem {
  overlay.overlay_offset(problem: unwrap_problem(problem), pixels: pixels)
  |> wrap_problem
}

/// Set the viewport padding used for safe placement.
///
/// Negative values are clamped to `0`.
pub fn overlay_padding(
  problem problem: OverlayProblem,
  pixels pixels: Int,
) -> OverlayProblem {
  overlay.overlay_padding(problem: unwrap_problem(problem), pixels: pixels)
  |> wrap_problem
}

/// Enable arrow output.
///
/// Sizes are clamped to be non-negative.
pub fn overlay_arrow(
  problem problem: OverlayProblem,
  size_px size_px: Int,
  edge_padding_px edge_padding_px: Int,
) -> OverlayProblem {
  overlay.overlay_arrow(
    problem: unwrap_problem(problem),
    size_px: size_px,
    edge_padding_px: edge_padding_px,
  )
  |> wrap_problem
}

/// Solve an overlay problem.
pub fn solve_overlay(problem problem: OverlayProblem) -> OverlaySolution {
  overlay.solve_overlay(problem: unwrap_problem(problem)) |> wrap_solution
}

/// Get the placement of a solution.
pub fn overlay_solution_placement(
  solution solution: OverlaySolution,
) -> OverlayPlacement {
  solution
  |> unwrap_solution
  |> overlay.overlay_solution_placement
  |> wrap_placement
}

/// Get the x coordinate of a solution.
pub fn overlay_solution_x(solution solution: OverlaySolution) -> Int {
  solution |> unwrap_solution |> overlay.overlay_solution_x
}

/// Get the y coordinate of a solution.
pub fn overlay_solution_y(solution solution: OverlaySolution) -> Int {
  solution |> unwrap_solution |> overlay.overlay_solution_y
}

/// Get the arrow x offset (above/below placements only).
pub fn overlay_solution_arrow_x(
  solution solution: OverlaySolution,
) -> Option(Int) {
  solution |> unwrap_solution |> overlay.overlay_solution_arrow_x
}

/// Get the arrow y offset (left/right placements only).
pub fn overlay_solution_arrow_y(
  solution solution: OverlaySolution,
) -> Option(Int) {
  solution |> unwrap_solution |> overlay.overlay_solution_arrow_y
}

/// A typed CSS position value.
pub opaque type Position {
  Position(value: String)
}

/// A typed CSS overflow value.
pub opaque type Overflow {
  Overflow(value: String)
}

/// A typed CSS justify-content value.
pub opaque type JustifyContent {
  JustifyContent(value: String)
}

/// A typed CSS align-items value.
pub opaque type AlignItems {
  AlignItems(value: String)
}

/// A typed CSS flex-wrap value.
pub opaque type FlexWrap {
  FlexWrap(value: String)
}

/// A typed CSS display value.
pub opaque type Display {
  Display(value: String)
}

/// A typed CSS vertical-align value.
pub opaque type VerticalAlign {
  VerticalAlign(value: String)
}

/// A single transform item (for example `translate(...)` or `scale(...)`).
pub opaque type TransformItem {
  TransformItem(value: String)
}

/// A typed CSS text-decoration value.
pub opaque type TextDecoration {
  TextDecoration(value: String)
}

/// A typed CSS user-select value.
pub opaque type UserSelect {
  UserSelect(value: String)
}

/// A typed CSS appearance value.
pub opaque type Appearance {
  Appearance(value: String)
}

/// A typed CSS overscroll-behavior value.
pub opaque type OverscrollBehavior {
  OverscrollBehavior(value: String)
}

/// A typed CSS scrollbar-gutter value.
pub opaque type ScrollbarGutter {
  ScrollbarGutter(value: String)
}

/// A typed CSS scrollbar-width value.
pub opaque type ScrollbarWidth {
  ScrollbarWidth(value: String)
}

/// A typed CSS scroll-behavior value.
pub opaque type ScrollBehavior {
  ScrollBehavior(value: String)
}

/// A typed CSS scroll-snap-type value.
pub opaque type ScrollSnapType {
  ScrollSnapType(value: String)
}

/// A typed CSS scroll-snap-align value.
pub opaque type ScrollSnapAlign {
  ScrollSnapAlign(value: String)
}

/// A typed CSS object-fit value (for replaced elements like images and videos).
pub opaque type ObjectFit {
  ObjectFit(value: String)
}

/// A single grid track size (for example `1fr`, `auto`, `minmax(...)`).
pub opaque type GridTrack {
  GridTrack(value: String)
}

/// A typed `grid-auto-flow` value.
pub opaque type GridAutoFlow {
  GridAutoFlow(value: String)
}

/// A typed `@media` query.
pub opaque type MediaQuery {
  MediaQuery(value: String)
}

/// A typed `@container` query.
pub opaque type ContainerQuery {
  ContainerQuery(value: String)
}

/// A font family token (named or generic).
pub opaque type FontFamily {
  FontFamily(value: String)
}

/// A typed CSS font-weight value.
pub opaque type FontWeight {
  FontWeight(value: String)
}

/// A typed CSS line-height value.
pub opaque type LineHeight {
  LineHeight(value: String)
}

/// A typed CSS text-align value.
pub opaque type TextAlign {
  TextAlign(value: String)
}

/// A typed CSS border style.
pub opaque type BorderStyle {
  BorderStyle(value: String)
}

/// A typed CSS white-space value.
pub opaque type WhiteSpace {
  WhiteSpace(value: String)
}

/// A typed CSS text-overflow value.
pub opaque type TextOverflow {
  TextOverflow(value: String)
}

/// A typed CSS text-transform value.
pub opaque type TextTransform {
  TextTransform(value: String)
}

/// A typed CSS word-break value.
pub opaque type WordBreak {
  WordBreak(value: String)
}

/// A typed CSS overflow-wrap value.
pub opaque type OverflowWrap {
  OverflowWrap(value: String)
}

/// A typed CSS color-scheme value.
pub opaque type ColorScheme {
  ColorScheme(value: String)
}

/// A single CSS filter function (for `filter` and `backdrop-filter`).
pub opaque type Filter {
  Filter(value: String)
}

/// A single CSS box-shadow entry.
pub opaque type Shadow {
  Shadow(
    inset: Bool,
    x: CssLength,
    y: CssLength,
    blur: CssLength,
    spread: CssLength,
    color: Color,
  )
}

/// A typed, safe set of layout and style attributes.
pub opaque type Attribute {
  Attribute(rule: Rule)
}

/// A compiled, named style rule-set.
pub opaque type Class {
  Class(name: String, rule: Rule, extra_classes: List(String))
}

type Declaration {
  Declaration(property: String, value: String)
}

type Rule {
  Rule(
    declarations: List(Declaration),
    pseudos: List(#(String, Rule)),
    medias: List(#(String, Rule)),
    containers: List(#(String, Rule)),
    ancestors: List(#(String, Rule)),
    extra_classes: List(String),
  )
}

fn rule_empty() -> Rule {
  Rule(
    declarations: [],
    pseudos: [],
    medias: [],
    containers: [],
    ancestors: [],
    extra_classes: [],
  )
}

fn rule_from_declarations(declarations: List(Declaration)) -> Rule {
  Rule(
    declarations: declarations,
    pseudos: [],
    medias: [],
    containers: [],
    ancestors: [],
    extra_classes: [],
  )
}

fn rule_merge(a: Rule, b: Rule) -> Rule {
  case a, b {
    Rule(
      declarations: a_decls,
      pseudos: a_pseudos,
      medias: a_medias,
      containers: a_containers,
      ancestors: a_ancestors,
      extra_classes: a_extra,
    ),
      Rule(
        declarations: b_decls,
        pseudos: b_pseudos,
        medias: b_medias,
        containers: b_containers,
        ancestors: b_ancestors,
        extra_classes: b_extra,
      )
    ->
      Rule(
        declarations: list.append(a_decls, b_decls),
        pseudos: keyed_rule_merge(a_pseudos, b_pseudos),
        medias: keyed_rule_merge(a_medias, b_medias),
        containers: keyed_rule_merge(a_containers, b_containers),
        ancestors: keyed_rule_merge(a_ancestors, b_ancestors),
        extra_classes: list.append(a_extra, b_extra),
      )
  }
}

fn keyed_rule_merge(
  existing: List(#(String, Rule)),
  new: List(#(String, Rule)),
) -> List(#(String, Rule)) {
  list.fold(new, existing, fn(acc, pair) {
    case pair {
      #(key, rule) -> keyed_rule_upsert(acc, key, rule)
    }
  })
}

fn keyed_rule_upsert(
  pairs: List(#(String, Rule)),
  key: String,
  add: Rule,
) -> List(#(String, Rule)) {
  case pairs {
    [] -> [#(key, add)]
    [#(k, r), ..rest] if k == key -> [#(k, rule_merge(r, add)), ..rest]
    [head, ..rest] -> [head, ..keyed_rule_upsert(rest, key, add)]
  }
}

fn rule_normalize(rule: Rule) -> Rule {
  case rule {
    Rule(
      declarations:,
      pseudos:,
      medias:,
      containers:,
      ancestors:,
      extra_classes:,
    ) ->
      Rule(
        declarations: declarations
          |> declarations_last_write_wins
          |> sort_declarations,
        pseudos: pseudos |> keyed_rule_normalize |> sort_keyed_rules,
        medias: medias |> keyed_rule_normalize |> sort_keyed_rules,
        containers: containers |> keyed_rule_normalize |> sort_keyed_rules,
        ancestors: ancestors |> keyed_rule_normalize |> sort_keyed_rules,
        extra_classes: extra_classes |> list.unique |> list.sort(string.compare),
      )
  }
}

fn keyed_rule_normalize(pairs: List(#(String, Rule))) -> List(#(String, Rule)) {
  list.map(pairs, fn(pair) {
    case pair {
      #(key, rule) -> #(key, rule_normalize(rule))
    }
  })
}

fn sort_declarations(declarations: List(Declaration)) -> List(Declaration) {
  list.sort(declarations, by: fn(a, b) {
    case a, b {
      Declaration(property: ap, value: _), Declaration(property: bp, value: _) ->
        string.compare(ap, bp)
    }
  })
}

fn sort_keyed_rules(pairs: List(#(String, Rule))) -> List(#(String, Rule)) {
  list.sort(pairs, by: fn(a, b) {
    case a, b {
      #(ak, _), #(bk, _) -> string.compare(ak, bk)
    }
  })
}

fn declarations_last_write_wins(
  declarations: List(Declaration),
) -> List(Declaration) {
  // Keep only the last declaration for each property.
  let #(kept, _) =
    list.fold_right(declarations, #([], []), fn(acc, decl) {
      let #(kept, seen) = acc
      case decl {
        Declaration(property:, value: _) ->
          case list.contains(seen, property) {
            True -> #(kept, seen)
            False -> #([decl, ..kept], [property, ..seen])
          }
      }
    })

  kept
}

fn attr(rule: Rule) -> Attribute {
  Attribute(rule: rule)
}

fn css_length_value(length: CssLength) -> String {
  case length {
    CssLength(value:) -> value
  }
}

fn normalize_float_string(value: Float, precision: Int) -> String {
  // Guard against NaN/infinities and BEAM overflow when we later scale the float
  // for rounding.
  case float.compare(value, with: value) {
    order.Eq -> {
      let scale = pow10(precision)
      let limit = 1.0e308 /. int.to_float(scale)
      let negative_limit = 0.0 -. limit
      case value >. limit || value <. negative_limit {
        True -> "0"
        False -> fixed_decimal_string(value, precision)
      }
    }
    _ -> "0"
  }
}

fn trim_trailing_char(value: String, char: String) -> String {
  case string.ends_with(value, char) {
    False -> value
    True -> value |> string.drop_end(up_to: 1) |> trim_trailing_char(char)
  }
}

fn css_length_from_float(unit: String, value: Float) -> CssLength {
  // 4 decimal places is enough for CSS layout work and keeps hashes stable.
  CssLength(value: normalize_float_string(value, 4) <> unit)
}

fn fixed_decimal_string(value: Float, precision: Int) -> String {
  let scale = pow10(precision)
  let scaled = float.round(value *. int.to_float(scale))

  let sign = case scaled < 0 {
    True -> "-"
    False -> ""
  }

  let scaled_abs = case scaled < 0 {
    True -> 0 - scaled
    False -> scaled
  }

  let whole = scaled_abs / scale
  let frac = scaled_abs - { whole * scale }

  case frac {
    0 -> sign <> int.to_string(whole)
    _ -> {
      let frac_str =
        frac
        |> int.to_string
        |> pad_left(precision, "0")
        |> trim_trailing_char("0")

      case frac_str {
        "" -> sign <> int.to_string(whole)
        _ -> sign <> int.to_string(whole) <> "." <> frac_str
      }
    }
  }
}

fn pow10(n: Int) -> Int {
  case n {
    0 -> 1
    _ -> 10 * pow10(n - 1)
  }
}

fn pad_left(value: String, to_length: Int, with: String) -> String {
  case string.length(value) >= to_length {
    True -> value
    False -> pad_left(with <> value, to_length, with)
  }
}

/// A CSS length in pixels.
pub fn px(pixels pixels: Int) -> CssLength {
  CssLength(value: int.to_string(pixels) <> "px")
}

/// A CSS length in `rem`.
pub fn rem(rem rem: Float) -> CssLength {
  css_length_from_float("rem", rem)
}

/// A CSS length in `em`.
pub fn em(em em: Float) -> CssLength {
  css_length_from_float("em", em)
}

/// A percentage length (for example `50%`).
pub fn pct(pct pct: Float) -> CssLength {
  css_length_from_float("%", pct)
}

/// A viewport width length (for example `10vw`).
pub fn vw(vw vw: Float) -> CssLength {
  css_length_from_float("vw", vw)
}

/// A viewport height length (for example `10vh`).
pub fn vh(vh vh: Float) -> CssLength {
  css_length_from_float("vh", vh)
}

/// CSS `fit-content` length — shrink-wraps to content width, bounded by available space.
///
/// Distinct from `shrink()` which generates `max-content` sizing via flex.
pub fn fit_content() -> CssLength {
  CssLength(value: "fit-content")
}

fn duration_value(duration: Duration) -> String {
  case duration {
    Duration(value:) -> value
  }
}

fn easing_value(easing: Easing) -> String {
  case easing {
    Easing(value:) -> value
  }
}

fn transition_property_value(property: TransitionProperty) -> String {
  case property {
    TransitionProperty(value:) -> value
  }
}

fn cursor_value(cursor: Cursor) -> String {
  case cursor {
    Cursor(value:) -> value
  }
}

fn pointer_events_value(pointer_events: PointerEvents) -> String {
  case pointer_events {
    PointerEvents(value:) -> value
  }
}

fn position_value(position: Position) -> String {
  case position {
    Position(value:) -> value
  }
}

fn overflow_value(overflow: Overflow) -> String {
  case overflow {
    Overflow(value:) -> value
  }
}

fn justify_content_value(value: JustifyContent) -> String {
  case value {
    JustifyContent(value:) -> value
  }
}

fn align_items_value(value: AlignItems) -> String {
  case value {
    AlignItems(value:) -> value
  }
}

fn flex_wrap_value(value: FlexWrap) -> String {
  case value {
    FlexWrap(value:) -> value
  }
}

fn display_value(value: Display) -> String {
  case value {
    Display(value:) -> value
  }
}

fn vertical_align_value(value: VerticalAlign) -> String {
  case value {
    VerticalAlign(value:) -> value
  }
}

fn transform_item_value(value: TransformItem) -> String {
  case value {
    TransformItem(value:) -> value
  }
}

fn text_decoration_value(value: TextDecoration) -> String {
  case value {
    TextDecoration(value:) -> value
  }
}

fn user_select_value(value: UserSelect) -> String {
  case value {
    UserSelect(value:) -> value
  }
}

fn appearance_value(value: Appearance) -> String {
  case value {
    Appearance(value:) -> value
  }
}

fn overscroll_behavior_value(behavior: OverscrollBehavior) -> String {
  case behavior {
    OverscrollBehavior(value:) -> value
  }
}

fn scrollbar_gutter_value(gutter: ScrollbarGutter) -> String {
  case gutter {
    ScrollbarGutter(value:) -> value
  }
}

fn scrollbar_width_value(width: ScrollbarWidth) -> String {
  case width {
    ScrollbarWidth(value:) -> value
  }
}

fn scroll_behavior_value(behavior: ScrollBehavior) -> String {
  case behavior {
    ScrollBehavior(value:) -> value
  }
}

fn scroll_snap_type_value(value: ScrollSnapType) -> String {
  case value {
    ScrollSnapType(value:) -> value
  }
}

fn scroll_snap_align_value(value: ScrollSnapAlign) -> String {
  case value {
    ScrollSnapAlign(value:) -> value
  }
}

fn object_fit_value(value: ObjectFit) -> String {
  case value {
    ObjectFit(value:) -> value
  }
}

fn grid_track_value(track: GridTrack) -> String {
  case track {
    GridTrack(value:) -> value
  }
}

fn grid_auto_flow_value(flow: GridAutoFlow) -> String {
  case flow {
    GridAutoFlow(value:) -> value
  }
}

fn media_query_value(query: MediaQuery) -> String {
  case query {
    MediaQuery(value:) -> value
  }
}

fn container_query_value(query: ContainerQuery) -> String {
  case query {
    ContainerQuery(value:) -> value
  }
}

fn font_family_value(family: FontFamily) -> String {
  case family {
    FontFamily(value:) -> value
  }
}

fn font_weight_css(weight: FontWeight) -> String {
  case weight {
    FontWeight(value:) -> value
  }
}

fn line_height_value(line_height: LineHeight) -> String {
  case line_height {
    LineHeight(value:) -> value
  }
}

fn text_align_value(align: TextAlign) -> String {
  case align {
    TextAlign(value:) -> value
  }
}

fn border_style_value(style: BorderStyle) -> String {
  case style {
    BorderStyle(value:) -> value
  }
}

fn white_space_value(ws: WhiteSpace) -> String {
  case ws {
    WhiteSpace(value:) -> value
  }
}

fn text_overflow_value(to: TextOverflow) -> String {
  case to {
    TextOverflow(value:) -> value
  }
}

fn text_transform_value(tt: TextTransform) -> String {
  case tt {
    TextTransform(value:) -> value
  }
}

fn word_break_value(wb: WordBreak) -> String {
  case wb {
    WordBreak(value:) -> value
  }
}

fn overflow_wrap_value(ow: OverflowWrap) -> String {
  case ow {
    OverflowWrap(value:) -> value
  }
}

fn color_scheme_value(cs: ColorScheme) -> String {
  case cs {
    ColorScheme(value:) -> value
  }
}

fn filter_value(f: Filter) -> String {
  case f {
    Filter(value:) -> value
  }
}

fn quote_css_string(value: String) -> String {
  let escaped =
    value
    |> string.replace(each: "\\", with: "\\\\")
    |> string.replace(each: "\"", with: "\\\"")

  "\"" <> escaped <> "\""
}

fn clamp_float(
  value: Float,
  min min_value: Float,
  max max_value: Float,
) -> Float {
  case float.compare(value, with: value) {
    order.Eq ->
      case value <. min_value {
        True -> min_value
        False ->
          case value >. max_value {
            True -> max_value
            False -> value
          }
      }
    _ -> 0.0
  }
}

fn clamp_non_negative(value: Float) -> Float {
  clamp_float(value, min: 0.0, max: 1.0e308)
}

/// A duration in milliseconds (clamped to be non-negative).
pub fn ms(milliseconds milliseconds: Int) -> Duration {
  let clamped = case milliseconds < 0 {
    True -> 0
    False -> milliseconds
  }

  Duration(value: int.to_string(clamped) <> "ms")
}

/// A duration in seconds (clamped to be non-negative).
pub fn s(seconds seconds: Float) -> Duration {
  let clamped = clamp_non_negative(seconds)
  Duration(value: normalize_float_string(clamped, 4) <> "s")
}

/// A linear timing function.
pub fn linear() -> Easing {
  Easing(value: "linear")
}

/// An ease timing function.
pub fn ease() -> Easing {
  Easing(value: "ease")
}

/// An ease-in timing function.
pub fn ease_in() -> Easing {
  Easing(value: "ease-in")
}

/// An ease-out timing function.
pub fn ease_out() -> Easing {
  Easing(value: "ease-out")
}

/// An ease-in-out timing function.
pub fn ease_in_out() -> Easing {
  Easing(value: "ease-in-out")
}

/// A cubic-bezier timing function.
///
/// `x1` and `x2` are clamped to `[0, 1]` to ensure a valid CSS value.
pub fn cubic_bezier(
  x1 x1: Float,
  y1 y1: Float,
  x2 x2: Float,
  y2 y2: Float,
) -> Easing {
  let x1 = clamp_float(x1, min: 0.0, max: 1.0)
  let x2 = clamp_float(x2, min: 0.0, max: 1.0)

  let y1 = clamp_float(y1, min: -1.0e308, max: 1.0e308)
  let y2 = clamp_float(y2, min: -1.0e308, max: 1.0e308)

  Easing(
    value: "cubic-bezier("
    <> normalize_float_string(x1, 4)
    <> ", "
    <> normalize_float_string(y1, 4)
    <> ", "
    <> normalize_float_string(x2, 4)
    <> ", "
    <> normalize_float_string(y2, 4)
    <> ")",
  )
}

/// Transition all properties.
pub fn transition_property_all() -> TransitionProperty {
  TransitionProperty(value: "all")
}

/// Transition the `opacity` property.
pub fn transition_property_opacity() -> TransitionProperty {
  TransitionProperty(value: "opacity")
}

/// Transition the `color` property.
pub fn transition_property_color() -> TransitionProperty {
  TransitionProperty(value: "color")
}

/// Transition the `background-color` property.
pub fn transition_property_background_color() -> TransitionProperty {
  TransitionProperty(value: "background-color")
}

/// Transition the `box-shadow` property.
pub fn transition_property_box_shadow() -> TransitionProperty {
  TransitionProperty(value: "box-shadow")
}

/// Transition the `transform` property.
pub fn transition_property_transform() -> TransitionProperty {
  TransitionProperty(value: "transform")
}

/// Create a single transition entry.
pub fn transition_item(
  property property: TransitionProperty,
  duration duration: Duration,
  easing easing: Easing,
) -> Transition {
  Transition(property:, duration:, easing:, delay: None)
}

/// Create a single transition entry with an explicit delay.
pub fn transition_item_with_delay(
  property property: TransitionProperty,
  duration duration: Duration,
  easing easing: Easing,
  delay delay: Duration,
) -> Transition {
  Transition(property:, duration:, easing:, delay: Some(delay))
}

/// The default cursor.
pub fn cursor_default() -> Cursor {
  Cursor(value: "default")
}

/// A pointer cursor (for clickable elements).
pub fn cursor_pointer() -> Cursor {
  Cursor(value: "pointer")
}

/// A text cursor (for selectable/typable text).
pub fn cursor_text() -> Cursor {
  Cursor(value: "text")
}

/// A not-allowed cursor.
pub fn cursor_not_allowed() -> Cursor {
  Cursor(value: "not-allowed")
}

/// A grab cursor.
pub fn cursor_grab() -> Cursor {
  Cursor(value: "grab")
}

/// A grabbing cursor.
pub fn cursor_grabbing() -> Cursor {
  Cursor(value: "grabbing")
}

/// Allow pointer events (default browser behavior).
pub fn pointer_events_auto() -> PointerEvents {
  PointerEvents(value: "auto")
}

/// Disable pointer events (useful for overlays and inert content).
pub fn pointer_events_none() -> PointerEvents {
  PointerEvents(value: "none")
}

/// Default positioning (static).
pub fn position_static() -> Position {
  Position(value: "static")
}

/// Relative positioning.
pub fn position_relative() -> Position {
  Position(value: "relative")
}

/// Absolute positioning.
pub fn position_absolute() -> Position {
  Position(value: "absolute")
}

/// Fixed positioning (relative to the viewport).
pub fn position_fixed() -> Position {
  Position(value: "fixed")
}

/// Sticky positioning.
pub fn position_sticky() -> Position {
  Position(value: "sticky")
}

/// Justify items at the start.
pub fn justify_start() -> JustifyContent {
  JustifyContent(value: "flex-start")
}

/// Center items along the main axis.
pub fn justify_center() -> JustifyContent {
  JustifyContent(value: "center")
}

/// Justify items at the end.
pub fn justify_end() -> JustifyContent {
  JustifyContent(value: "flex-end")
}

/// Distribute items with space between.
pub fn justify_space_between() -> JustifyContent {
  JustifyContent(value: "space-between")
}

/// Distribute items with space around.
pub fn justify_space_around() -> JustifyContent {
  JustifyContent(value: "space-around")
}

/// Distribute items with equal space.
pub fn justify_space_evenly() -> JustifyContent {
  JustifyContent(value: "space-evenly")
}

/// Stretch items to fill the cross axis.
pub fn align_items_stretch() -> AlignItems {
  AlignItems(value: "stretch")
}

/// Align items at the start of the cross axis.
pub fn align_items_start() -> AlignItems {
  AlignItems(value: "flex-start")
}

/// Center items along the cross axis.
pub fn align_items_center() -> AlignItems {
  AlignItems(value: "center")
}

/// Align items at the end of the cross axis.
pub fn align_items_end() -> AlignItems {
  AlignItems(value: "flex-end")
}

/// Align items by their baseline.
pub fn align_items_baseline() -> AlignItems {
  AlignItems(value: "baseline")
}

/// Do not wrap flex items.
pub fn flex_nowrap() -> FlexWrap {
  FlexWrap(value: "nowrap")
}

/// Wrap flex items onto multiple lines.
pub fn wrap() -> FlexWrap {
  FlexWrap(value: "wrap")
}

/// Wrap flex items in reverse order.
pub fn wrap_reverse() -> FlexWrap {
  FlexWrap(value: "wrap-reverse")
}

/// Display as a block element.
pub fn display_block() -> Display {
  Display(value: "block")
}

/// Display as an inline element.
pub fn display_inline() -> Display {
  Display(value: "inline")
}

/// Display as an inline-block element.
pub fn display_inline_block() -> Display {
  Display(value: "inline-block")
}

/// Display as a flex container.
pub fn display_flex() -> Display {
  Display(value: "flex")
}

/// Display as an inline flex container.
pub fn display_inline_flex() -> Display {
  Display(value: "inline-flex")
}

/// Display as a grid container.
pub fn display_grid() -> Display {
  Display(value: "grid")
}

/// Align to the baseline.
pub fn vertical_align_baseline() -> VerticalAlign {
  VerticalAlign(value: "baseline")
}

/// Align to the middle.
pub fn vertical_align_middle() -> VerticalAlign {
  VerticalAlign(value: "middle")
}

/// Align to the top.
pub fn vertical_align_top() -> VerticalAlign {
  VerticalAlign(value: "top")
}

/// Align to the bottom.
pub fn vertical_align_bottom() -> VerticalAlign {
  VerticalAlign(value: "bottom")
}

/// Align vertically by a fixed length.
pub fn vertical_align_length(length length: CssLength) -> VerticalAlign {
  VerticalAlign(value: css_length_value(length))
}

/// Translate by the given offsets.
pub fn translate(x x: CssLength, y y: CssLength) -> TransformItem {
  TransformItem(
    value: "translate("
    <> css_length_value(x)
    <> ", "
    <> css_length_value(y)
    <> ")",
  )
}

/// Scale by the given factors.
///
/// Values are clamped to be non-negative.
pub fn scale(x x: Float, y y: Float) -> TransformItem {
  let clamped_x = clamp_float(x, min: 0.0, max: 1.0e308)
  let clamped_y = clamp_float(y, min: 0.0, max: 1.0e308)

  TransformItem(
    value: "scale("
    <> normalize_float_string(clamped_x, 4)
    <> ", "
    <> normalize_float_string(clamped_y, 4)
    <> ")",
  )
}

/// Rotate by the given degrees.
pub fn rotate_degrees(deg deg: Float) -> TransformItem {
  let clamped = clamp_float(deg, min: 0.0 -. 1.0e308, max: 1.0e308)
  TransformItem(
    value: "rotate(" <> normalize_float_string(clamped, 4) <> "deg)",
  )
}

/// No text decoration.
pub fn text_decoration_none() -> TextDecoration {
  TextDecoration(value: "none")
}

/// Underline text.
pub fn text_decoration_underline() -> TextDecoration {
  TextDecoration(value: "underline")
}

/// Strike through text.
pub fn text_decoration_line_through() -> TextDecoration {
  TextDecoration(value: "line-through")
}

/// Default user selection behavior.
pub fn user_select_auto() -> UserSelect {
  UserSelect(value: "auto")
}

/// Prevent user selection.
pub fn user_select_none() -> UserSelect {
  UserSelect(value: "none")
}

/// Allow user selection.
pub fn user_select_text() -> UserSelect {
  UserSelect(value: "text")
}

/// Select all content on interaction (where supported).
pub fn user_select_all() -> UserSelect {
  UserSelect(value: "all")
}

/// Default appearance.
pub fn appearance_auto() -> Appearance {
  Appearance(value: "auto")
}

/// No platform-native appearance.
pub fn appearance_none() -> Appearance {
  Appearance(value: "none")
}

/// Overflow is visible (default browser behavior).
pub fn overflow_visible() -> Overflow {
  Overflow(value: "visible")
}

/// Hide overflowing content.
pub fn overflow_hidden() -> Overflow {
  Overflow(value: "hidden")
}

/// Clip overflowing content without scrollbars.
pub fn overflow_clip() -> Overflow {
  Overflow(value: "clip")
}

/// Always show scrollbars (where supported).
pub fn overflow_scroll() -> Overflow {
  Overflow(value: "scroll")
}

/// Show scrollbars only when needed.
pub fn overflow_auto() -> Overflow {
  Overflow(value: "auto")
}

/// The default overscroll behavior.
pub fn overscroll_auto() -> OverscrollBehavior {
  OverscrollBehavior(value: "auto")
}

/// Prevent scroll chaining and overscroll bounce.
pub fn overscroll_contain() -> OverscrollBehavior {
  OverscrollBehavior(value: "contain")
}

/// Disable overscroll behavior.
pub fn overscroll_none() -> OverscrollBehavior {
  OverscrollBehavior(value: "none")
}

/// The default scrollbar gutter behavior.
pub fn scrollbar_gutter_auto() -> ScrollbarGutter {
  ScrollbarGutter(value: "auto")
}

/// Reserve space for scrollbars to avoid layout shifts.
pub fn scrollbar_gutter_stable() -> ScrollbarGutter {
  ScrollbarGutter(value: "stable")
}

/// Reserve space for scrollbars on both edges.
pub fn scrollbar_gutter_stable_both_edges() -> ScrollbarGutter {
  ScrollbarGutter(value: "stable both-edges")
}

/// The default scrollbar width.
pub fn scrollbar_width_auto() -> ScrollbarWidth {
  ScrollbarWidth(value: "auto")
}

/// A thin scrollbar width.
pub fn scrollbar_width_thin() -> ScrollbarWidth {
  ScrollbarWidth(value: "thin")
}

/// Hide the scrollbar (where supported).
pub fn scrollbar_width_none() -> ScrollbarWidth {
  ScrollbarWidth(value: "none")
}

/// Default scroll behavior.
pub fn scroll_behavior_auto() -> ScrollBehavior {
  ScrollBehavior(value: "auto")
}

/// Smooth scrolling behavior.
pub fn scroll_behavior_smooth() -> ScrollBehavior {
  ScrollBehavior(value: "smooth")
}

/// Disable scroll snapping.
pub fn scroll_snap_type_none() -> ScrollSnapType {
  ScrollSnapType(value: "none")
}

/// Horizontal mandatory scroll snapping.
pub fn scroll_snap_type_x_mandatory() -> ScrollSnapType {
  ScrollSnapType(value: "x mandatory")
}

/// Vertical mandatory scroll snapping.
pub fn scroll_snap_type_y_mandatory() -> ScrollSnapType {
  ScrollSnapType(value: "y mandatory")
}

/// Mandatory scroll snapping on both axes.
pub fn scroll_snap_type_both_mandatory() -> ScrollSnapType {
  ScrollSnapType(value: "both mandatory")
}

/// Horizontal proximity scroll snapping.
pub fn scroll_snap_type_x_proximity() -> ScrollSnapType {
  ScrollSnapType(value: "x proximity")
}

/// Vertical proximity scroll snapping.
pub fn scroll_snap_type_y_proximity() -> ScrollSnapType {
  ScrollSnapType(value: "y proximity")
}

/// Proximity scroll snapping on both axes.
pub fn scroll_snap_type_both_proximity() -> ScrollSnapType {
  ScrollSnapType(value: "both proximity")
}

/// No scroll snap alignment.
pub fn scroll_snap_align_none() -> ScrollSnapAlign {
  ScrollSnapAlign(value: "none")
}

/// Snap to the start of the snap container.
pub fn scroll_snap_align_start() -> ScrollSnapAlign {
  ScrollSnapAlign(value: "start")
}

/// Snap to the end of the snap container.
pub fn scroll_snap_align_end() -> ScrollSnapAlign {
  ScrollSnapAlign(value: "end")
}

/// Snap to the center of the snap container.
pub fn scroll_snap_align_center() -> ScrollSnapAlign {
  ScrollSnapAlign(value: "center")
}

/// Stretch replaced content to fill its box.
pub fn object_fit_fill() -> ObjectFit {
  ObjectFit(value: "fill")
}

/// Scale replaced content to fit within its box, preserving aspect ratio.
pub fn object_fit_contain() -> ObjectFit {
  ObjectFit(value: "contain")
}

/// Scale replaced content to cover its box, preserving aspect ratio.
pub fn object_fit_cover() -> ObjectFit {
  ObjectFit(value: "cover")
}

/// Do not resize replaced content.
pub fn object_fit_none() -> ObjectFit {
  ObjectFit(value: "none")
}

/// Scale replaced content down to fit, but never up.
pub fn object_fit_scale_down() -> ObjectFit {
  ObjectFit(value: "scale-down")
}

/// An `auto` grid track.
pub fn grid_auto() -> GridTrack {
  GridTrack(value: "auto")
}

/// A `min-content` grid track.
pub fn grid_min_content() -> GridTrack {
  GridTrack(value: "min-content")
}

/// A `max-content` grid track.
pub fn grid_max_content() -> GridTrack {
  GridTrack(value: "max-content")
}

/// A fixed grid track length (px/rem/etc).
pub fn grid_fixed(length length: CssLength) -> GridTrack {
  GridTrack(value: css_length_value(length))
}

/// A fractional (`fr`) grid track.
///
/// Values are clamped to be non-negative.
pub fn grid_fr(fr fr: Float) -> GridTrack {
  let clamped = clamp_float(fr, min: 0.0, max: 1.0e308)
  GridTrack(value: normalize_float_string(clamped, 4) <> "fr")
}

/// A `minmax(min, max)` grid track.
pub fn grid_minmax(min min: GridTrack, max max: GridTrack) -> GridTrack {
  GridTrack(
    value: "minmax("
    <> grid_track_value(min)
    <> ", "
    <> grid_track_value(max)
    <> ")",
  )
}

/// A `fit-content(length)` grid track.
pub fn grid_fit_content(length length: CssLength) -> GridTrack {
  GridTrack(value: "fit-content(" <> css_length_value(length) <> ")")
}

/// A `repeat(count, track)` grid track.
///
/// `count` is clamped to be at least `1`.
pub fn grid_repeat(count count: Int, track track: GridTrack) -> GridTrack {
  let c = case count < 1 {
    True -> 1
    False -> count
  }

  GridTrack(
    value: "repeat("
    <> int.to_string(c)
    <> ", "
    <> grid_track_value(track)
    <> ")",
  )
}

/// Auto-place grid items by row.
pub fn grid_auto_flow_row() -> GridAutoFlow {
  GridAutoFlow(value: "row")
}

/// Auto-place grid items by column.
pub fn grid_auto_flow_column() -> GridAutoFlow {
  GridAutoFlow(value: "column")
}

/// Auto-place grid items by row, using dense packing.
pub fn grid_auto_flow_row_dense() -> GridAutoFlow {
  GridAutoFlow(value: "row dense")
}

/// Auto-place grid items by column, using dense packing.
pub fn grid_auto_flow_column_dense() -> GridAutoFlow {
  GridAutoFlow(value: "column dense")
}

/// A `min-width` media query.
pub fn min_width(length length: CssLength) -> MediaQuery {
  MediaQuery(value: "(min-width:" <> css_length_value(length) <> ")")
}

/// A `max-width` media query.
pub fn max_width(length length: CssLength) -> MediaQuery {
  MediaQuery(value: "(max-width:" <> css_length_value(length) <> ")")
}

/// An unnamed `min-width` container query.
pub fn container_min_width(length length: CssLength) -> ContainerQuery {
  ContainerQuery(value: "(min-width:" <> css_length_value(length) <> ")")
}

/// An unnamed `max-width` container query.
pub fn container_max_width(length length: CssLength) -> ContainerQuery {
  ContainerQuery(value: "(max-width:" <> css_length_value(length) <> ")")
}

/// A `prefers-reduced-motion: reduce` media query.
pub fn prefers_reduced_motion() -> MediaQuery {
  MediaQuery(value: "(prefers-reduced-motion:reduce)")
}

/// A `prefers-color-scheme: dark` media query.
pub fn prefers_color_scheme_dark() -> MediaQuery {
  MediaQuery(value: "(prefers-color-scheme:dark)")
}

/// A `prefers-color-scheme: light` media query.
pub fn prefers_color_scheme_light() -> MediaQuery {
  MediaQuery(value: "(prefers-color-scheme:light)")
}

/// Combine two media queries with `and`.
pub fn media_and(left left: MediaQuery, right right: MediaQuery) -> MediaQuery {
  MediaQuery(
    value: media_query_value(left) <> " and " <> media_query_value(right),
  )
}

/// Combine two container queries with `and`.
pub fn container_and(
  left left: ContainerQuery,
  right right: ContainerQuery,
) -> ContainerQuery {
  ContainerQuery(
    value: container_query_value(left)
    <> " and "
    <> container_query_value(right),
  )
}

/// A named font family.
///
/// The name is safely quoted and escaped for use in CSS.
pub fn font(name name: String) -> FontFamily {
  let trimmed = string.trim(name)
  case trimmed {
    "" -> font_sans_serif()
    _ -> FontFamily(value: quote_css_string(trimmed))
  }
}

/// The generic `sans-serif` font family.
pub fn font_sans_serif() -> FontFamily {
  FontFamily(value: "sans-serif")
}

/// The generic `serif` font family.
pub fn font_serif() -> FontFamily {
  FontFamily(value: "serif")
}

/// The generic `monospace` font family.
pub fn font_monospace() -> FontFamily {
  FontFamily(value: "monospace")
}

/// The generic `system-ui` font family.
pub fn font_system_ui() -> FontFamily {
  FontFamily(value: "system-ui")
}

/// The generic `emoji` font family.
pub fn font_emoji() -> FontFamily {
  FontFamily(value: "emoji")
}

/// The `normal` font weight.
pub fn font_weight_normal() -> FontWeight {
  FontWeight(value: "normal")
}

/// The `bold` font weight.
pub fn font_weight_bold() -> FontWeight {
  FontWeight(value: "bold")
}

/// A numeric font weight (clamped to `1..1000`).
pub fn font_weight_value(weight weight: Int) -> FontWeight {
  let clamped = case weight < 1 {
    True -> 1
    False ->
      case weight > 1000 {
        True -> 1000
        False -> weight
      }
  }

  FontWeight(value: int.to_string(clamped))
}

/// A `normal` line height.
pub fn line_height_normal() -> LineHeight {
  LineHeight(value: "normal")
}

/// A unitless line-height multiplier (clamped to be non-negative).
pub fn line_height_multiple(multiplier multiplier: Float) -> LineHeight {
  let clamped = clamp_non_negative(multiplier)
  LineHeight(value: normalize_float_string(clamped, 4))
}

/// A line height expressed as a length.
pub fn line_height_length(length length: CssLength) -> LineHeight {
  LineHeight(value: css_length_value(length))
}

/// Text aligned to the left.
pub fn text_align_left() -> TextAlign {
  TextAlign(value: "left")
}

/// Text aligned to the center.
pub fn text_align_center() -> TextAlign {
  TextAlign(value: "center")
}

/// Text aligned to the right.
pub fn text_align_right() -> TextAlign {
  TextAlign(value: "right")
}

/// Justified text alignment.
pub fn text_align_justify() -> TextAlign {
  TextAlign(value: "justify")
}

/// A solid border style.
pub fn border_style_solid() -> BorderStyle {
  BorderStyle(value: "solid")
}

/// A dashed border style.
pub fn border_style_dashed() -> BorderStyle {
  BorderStyle(value: "dashed")
}

/// A dotted border style.
pub fn border_style_dotted() -> BorderStyle {
  BorderStyle(value: "dotted")
}

/// No border style.
pub fn border_style_none() -> BorderStyle {
  BorderStyle(value: "none")
}

// --- WhiteSpace constructors ------------------------------------------------

/// Normal white-space handling (collapses whitespace, wraps at soft breaks).
pub fn white_space_normal() -> WhiteSpace {
  WhiteSpace(value: "normal")
}

/// Prevent text from wrapping to the next line.
pub fn white_space_nowrap() -> WhiteSpace {
  WhiteSpace(value: "nowrap")
}

/// Preserve whitespace as authored (like `<pre>`).
pub fn white_space_pre() -> WhiteSpace {
  WhiteSpace(value: "pre")
}

/// Preserve whitespace but allow wrapping at soft breaks.
pub fn white_space_pre_wrap() -> WhiteSpace {
  WhiteSpace(value: "pre-wrap")
}

/// Collapse whitespace but preserve newlines.
pub fn white_space_pre_line() -> WhiteSpace {
  WhiteSpace(value: "pre-line")
}

// --- TextOverflow constructors ----------------------------------------------

/// Clip overflowing text (default browser behavior).
pub fn text_overflow_clip() -> TextOverflow {
  TextOverflow(value: "clip")
}

/// Show an ellipsis when text overflows its container.
pub fn text_overflow_ellipsis() -> TextOverflow {
  TextOverflow(value: "ellipsis")
}

// --- TextTransform constructors ---------------------------------------------

/// Transform text to uppercase.
pub fn text_transform_uppercase() -> TextTransform {
  TextTransform(value: "uppercase")
}

/// Transform text to lowercase.
pub fn text_transform_lowercase() -> TextTransform {
  TextTransform(value: "lowercase")
}

/// Capitalize the first letter of each word.
pub fn text_transform_capitalize() -> TextTransform {
  TextTransform(value: "capitalize")
}

/// No text transformation.
pub fn text_transform_none() -> TextTransform {
  TextTransform(value: "none")
}

// --- WordBreak constructors -------------------------------------------------

/// Break words at any character to prevent overflow.
pub fn word_break_break_all() -> WordBreak {
  WordBreak(value: "break-all")
}

/// Only break at word boundaries except where overflow would occur.
pub fn word_break_break_word() -> WordBreak {
  WordBreak(value: "break-word")
}

/// Do not break CJK text (keep runs together).
pub fn word_break_keep_all() -> WordBreak {
  WordBreak(value: "keep-all")
}

// --- OverflowWrap constructors ----------------------------------------------

/// Allow breaking at any point if no other break opportunity exists.
pub fn overflow_wrap_anywhere() -> OverflowWrap {
  OverflowWrap(value: "anywhere")
}

/// Break long words only if they would otherwise overflow.
pub fn overflow_wrap_break_word() -> OverflowWrap {
  OverflowWrap(value: "break-word")
}

// --- ColorScheme constructors -----------------------------------------------

/// Indicate this element uses a light color scheme (native controls render light).
pub fn color_scheme_light() -> ColorScheme {
  ColorScheme(value: "light")
}

/// Indicate this element uses a dark color scheme (native controls render dark).
pub fn color_scheme_dark() -> ColorScheme {
  ColorScheme(value: "dark")
}

/// Indicate this element supports both light and dark color schemes.
pub fn color_scheme_light_dark() -> ColorScheme {
  ColorScheme(value: "light dark")
}

// --- Filter constructors ----------------------------------------------------

/// A blur filter function.
pub fn filter_blur(radius radius: CssLength) -> Filter {
  Filter(value: "blur(" <> css_length_value(radius) <> ")")
}

/// A brightness filter function (1.0 = unchanged).
pub fn filter_brightness(amount amount: Float) -> Filter {
  Filter(value: "brightness(" <> normalize_float_string(amount, 4) <> ")")
}

/// A contrast filter function (1.0 = unchanged).
pub fn filter_contrast(amount amount: Float) -> Filter {
  Filter(value: "contrast(" <> normalize_float_string(amount, 4) <> ")")
}

/// A saturation filter function (1.0 = unchanged, 0.0 = grayscale).
pub fn filter_saturate(amount amount: Float) -> Filter {
  Filter(value: "saturate(" <> normalize_float_string(amount, 4) <> ")")
}

/// An opacity filter function (1.0 = fully opaque, 0.0 = fully transparent).
pub fn filter_opacity(amount amount: Float) -> Filter {
  let clamped = clamp_float(amount, min: 0.0, max: 1.0)
  Filter(value: "opacity(" <> normalize_float_string(clamped, 4) <> ")")
}

/// Create a single `box-shadow` entry.
pub fn shadow(
  x x: CssLength,
  y y: CssLength,
  blur blur: CssLength,
  spread spread: CssLength,
  color color: Color,
) -> Shadow {
  Shadow(inset: False, x:, y:, blur:, spread:, color:)
}

/// Create a single `inset` `box-shadow` entry.
pub fn inner_shadow(
  x x: CssLength,
  y y: CssLength,
  blur blur: CssLength,
  spread spread: CssLength,
  color color: Color,
) -> Shadow {
  Shadow(inset: True, x:, y:, blur:, spread:, color:)
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
pub fn fill_portion(portion portion: Int) -> Length {
  FillPortion(portion)
}

/// A fixed length.
pub fn fixed(length length: CssLength) -> Length {
  Fixed(length)
}

/// Combine a base length with a minimum constraint.
pub fn minimum(base base: Length, min min: CssLength) -> Length {
  Minimum(base, min)
}

/// Combine a base length with a maximum constraint.
pub fn maximum(base base: Length, max max: CssLength) -> Length {
  Maximum(base, max)
}

/// Construct an RGB color.
pub fn rgb(red red: Int, green green: Int, blue blue: Int) -> Color {
  Color(
    value: "rgb("
    <> int.to_string(red)
    <> ", "
    <> int.to_string(green)
    <> ", "
    <> int.to_string(blue)
    <> ")",
  )
}

/// Construct an RGBA color.
pub fn rgba(
  red red: Int,
  green green: Int,
  blue blue: Int,
  alpha alpha: Float,
) -> Color {
  // Keep alpha stable across targets by clamping and normalizing.
  let a = normalize_float_string(clamp_float(alpha, min: 0.0, max: 1.0), 4)
  Color(
    value: "rgba("
    <> int.to_string(red)
    <> ", "
    <> int.to_string(green)
    <> ", "
    <> int.to_string(blue)
    <> ", "
    <> a
    <> ")",
  )
}

/// Construct an HSL color.
pub fn hsl(
  hue hue: Int,
  saturation saturation: Int,
  lightness lightness: Int,
) -> Color {
  Color(
    value: "hsl("
    <> int.to_string(hue)
    <> ", "
    <> int.to_string(saturation)
    <> "%, "
    <> int.to_string(lightness)
    <> "%)",
  )
}

/// Construct an HSLA color with alpha channel.
pub fn hsla(
  hue hue: Int,
  saturation saturation: Int,
  lightness lightness: Int,
  alpha alpha: Float,
) -> Color {
  let a = normalize_float_string(clamp_float(alpha, min: 0.0, max: 1.0), 4)
  Color(
    value: "hsla("
    <> int.to_string(hue)
    <> ", "
    <> int.to_string(saturation)
    <> "%, "
    <> int.to_string(lightness)
    <> "%, "
    <> a
    <> ")",
  )
}

/// A fully transparent color.
pub fn transparent() -> Color {
  Color(value: "transparent")
}

/// The `currentColor` CSS keyword — inherits the element's `color` property.
pub fn current_color() -> Color {
  Color(value: "currentColor")
}

/// Construct a Color from a hex string (e.g. `"#ff0000"` or `"#ccc"`).
///
/// The string is used as-is -- no validation is performed.  This is an
/// escape hatch for CSS hex color literals that cannot be expressed
/// through `rgb()` / `hsl()` constructors.
pub fn hex(value value: String) -> Color {
  Color(value: value)
}

/// Construct a Color from a CSS `var()` reference.
///
/// Wraps the given CSS custom-property expression as a typed Color so
/// it can flow through APIs that require `weft.Color`.  The string is
/// embedded verbatim -- callers are responsible for well-formed syntax
/// (e.g. `"var(--my-color, #fff)"`).
pub fn css_color(value value: String) -> Color {
  Color(value: value)
}

/// The CSS keyword `none`, used where an absent color is needed
/// (for example `fill: none` in SVG).
pub fn none_color() -> Color {
  Color(value: "none")
}

/// Serialize a typed `Color` to its CSS string representation.
///
/// Useful for passing weft colors to APIs that require raw CSS strings
/// (for example SVG attributes or third-party chart libraries).
pub fn color_to_css(color color: Color) -> String {
  color_value(color)
}

fn color_value(color: Color) -> String {
  case color {
    Color(value:) -> value
  }
}

fn gradient_stop_value(stop: GradientStop) -> String {
  case stop {
    GradientStop(value:) -> value
  }
}

fn linear_gradient_value(gradient: LinearGradient) -> String {
  case gradient {
    LinearGradient(value:) -> value
  }
}

/// The base layout rules for a row container.
pub fn row_layout() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "display", value: "flex"),
      Declaration(property: "flex-direction", value: "row"),
      Declaration(property: "box-sizing", value: "border-box"),
      Declaration(property: "min-width", value: "0"),
      Declaration(property: "min-height", value: "0"),
    ]),
  )
}

/// The base layout rules for a column container.
pub fn column_layout() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "display", value: "flex"),
      Declaration(property: "flex-direction", value: "column"),
      Declaration(property: "box-sizing", value: "border-box"),
      Declaration(property: "min-width", value: "0"),
      Declaration(property: "min-height", value: "0"),
    ]),
  )
}

/// The base layout rules for a grid container.
pub fn grid_layout() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "display", value: "grid"),
      Declaration(property: "box-sizing", value: "border-box"),
      Declaration(property: "min-width", value: "0"),
      Declaration(property: "min-height", value: "0"),
    ]),
  )
}

/// The base layout rules for a generic element container.
pub fn el_layout() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "box-sizing", value: "border-box"),
      Declaration(property: "min-width", value: "0"),
      Declaration(property: "min-height", value: "0"),
    ]),
  )
}

/// Set the gap (spacing) between children in a layout container.
pub fn spacing(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "gap", value: int.to_string(pixels) <> "px"),
    ]),
  )
}

/// Set uniform padding.
pub fn padding(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "padding", value: int.to_string(pixels) <> "px"),
    ]),
  )
}

/// Set padding with separate x (left/right) and y (top/bottom) values.
pub fn padding_xy(x x: Int, y y: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "padding",
        value: int.to_string(y) <> "px " <> int.to_string(x) <> "px",
      ),
    ]),
  )
}

/// Apply top padding only.
pub fn padding_top(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "padding-top", value: int.to_string(pixels) <> "px"),
    ]),
  )
}

/// Apply bottom padding only.
pub fn padding_bottom(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "padding-bottom",
        value: int.to_string(pixels) <> "px",
      ),
    ]),
  )
}

/// Apply left padding only.
pub fn padding_left(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "padding-left",
        value: int.to_string(pixels) <> "px",
      ),
    ]),
  )
}

/// Apply right padding only.
pub fn padding_right(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "padding-right",
        value: int.to_string(pixels) <> "px",
      ),
    ]),
  )
}

/// Center an element horizontally within its container.
pub fn center_x() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-left", value: "auto"),
      Declaration(property: "margin-right", value: "auto"),
    ]),
  )
}

/// Center an element vertically within its container.
pub fn center_y() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-top", value: "auto"),
      Declaration(property: "margin-bottom", value: "auto"),
    ]),
  )
}

/// Align an element to the left within its container.
pub fn align_left() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-left", value: "0"),
      Declaration(property: "margin-right", value: "auto"),
    ]),
  )
}

/// Align an element to the right within its container.
pub fn align_right() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-left", value: "auto"),
      Declaration(property: "margin-right", value: "0"),
    ]),
  )
}

/// Align an element to the top within its container.
pub fn align_top() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-top", value: "0"),
      Declaration(property: "margin-bottom", value: "auto"),
    ]),
  )
}

/// Align an element to the bottom within its container.
pub fn align_bottom() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-top", value: "auto"),
      Declaration(property: "margin-bottom", value: "0"),
    ]),
  )
}

/// Set the background color for an element.
pub fn background(color color: Color) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "background-color", value: color_value(color)),
    ]),
  )
}

/// Set a linear gradient background image.
pub fn background_gradient(gradient gradient: LinearGradient) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "background-image",
        value: linear_gradient_value(gradient),
      ),
    ]),
  )
}

/// Set the text color for an element.
pub fn text_color(color color: Color) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "color", value: color_value(color)),
    ]),
  )
}

/// Set the accent color used by form controls such as checkboxes and radios.
pub fn accent_color(color color: Color) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "accent-color", value: color_value(color)),
    ]),
  )
}

fn width_declarations(length: Length) -> List(Declaration) {
  case length {
    Fill -> [
      Declaration(property: "flex-grow", value: "1"),
      Declaration(property: "flex-basis", value: "0"),
    ]

    Shrink -> [
      Declaration(property: "flex-grow", value: "0"),
      Declaration(property: "flex-basis", value: "auto"),
    ]

    FillPortion(portion) -> [
      Declaration(property: "flex-grow", value: int.to_string(portion)),
      Declaration(property: "flex-basis", value: "0"),
    ]

    Fixed(css_length) -> [
      Declaration(property: "width", value: css_length_value(css_length)),
      Declaration(property: "flex-grow", value: "0"),
      Declaration(property: "flex-shrink", value: "0"),
    ]

    Minimum(base, min) -> {
      let base_decls = width_declarations(base)
      list.append(base_decls, [
        Declaration(property: "min-width", value: css_length_value(min)),
      ])
    }

    Maximum(base, max) -> {
      let base_decls = width_declarations(base)
      list.append(base_decls, [
        Declaration(property: "max-width", value: css_length_value(max)),
      ])
    }
  }
}

fn height_declarations(length: Length) -> List(Declaration) {
  case length {
    Fill -> [
      Declaration(property: "flex-grow", value: "1"),
      Declaration(property: "flex-basis", value: "0"),
    ]

    Shrink -> [
      Declaration(property: "flex-grow", value: "0"),
      Declaration(property: "flex-basis", value: "auto"),
    ]

    FillPortion(portion) -> [
      Declaration(property: "flex-grow", value: int.to_string(portion)),
      Declaration(property: "flex-basis", value: "0"),
    ]

    Fixed(css_length) -> [
      Declaration(property: "height", value: css_length_value(css_length)),
      Declaration(property: "flex-grow", value: "0"),
      Declaration(property: "flex-shrink", value: "0"),
    ]

    Minimum(base, min) -> {
      let base_decls = height_declarations(base)
      list.append(base_decls, [
        Declaration(property: "min-height", value: css_length_value(min)),
      ])
    }

    Maximum(base, max) -> {
      let base_decls = height_declarations(base)
      list.append(base_decls, [
        Declaration(property: "max-height", value: css_length_value(max)),
      ])
    }
  }
}

/// Set an element's width using a `Length`.
pub fn width(length length: Length) -> Attribute {
  attr(rule_from_declarations(width_declarations(length)))
}

/// Set an element's height using a `Length`.
pub fn height(length length: Length) -> Attribute {
  attr(rule_from_declarations(height_declarations(length)))
}

/// Create a gradient stop using the given color.
pub fn gradient_stop(color color: Color) -> GradientStop {
  GradientStop(value: color_value(color))
}

/// Create a gradient stop at a percentage position.
///
/// The percentage is clamped to `[0, 100]`.
pub fn gradient_stop_at(color color: Color, pct pct: Float) -> GradientStop {
  let p = clamp_float(pct, min: 0.0, max: 100.0)
  GradientStop(
    value: color_value(color) <> " " <> normalize_float_string(p, 4) <> "%",
  )
}

fn linear_gradient_body(degrees: Float, stops: List(GradientStop)) -> String {
  let d = normalize_float_string(degrees, 4) <> "deg"

  let stops = case stops {
    [] -> [
      GradientStop(value: "transparent"),
      GradientStop(value: "transparent"),
    ]
    [one] -> [one, one]
    many -> many
  }

  "linear-gradient("
  <> d
  <> ", "
  <> { stops |> list.map(gradient_stop_value) |> string.join(with: ", ") }
  <> ")"
}

/// Create a linear gradient flowing "down" (equivalent to `180deg`).
pub fn linear_gradient(stops stops: List(GradientStop)) -> LinearGradient {
  LinearGradient(value: linear_gradient_body(180.0, stops))
}

/// Create a linear gradient with an explicit direction in degrees.
pub fn linear_gradient_degrees(
  degrees degrees: Float,
  stops stops: List(GradientStop),
) -> LinearGradient {
  LinearGradient(value: linear_gradient_body(degrees, stops))
}

fn transition_key(transition: Transition) -> String {
  case transition {
    Transition(property:, duration: _, easing: _, delay: _) ->
      transition_property_value(property)
  }
}

fn transition_to_string(transition: Transition) -> String {
  case transition {
    Transition(property:, duration:, easing:, delay:) -> {
      let base =
        transition_property_value(property)
        <> " "
        <> duration_value(duration)
        <> " "
        <> easing_value(easing)

      case delay {
        None -> base
        Some(d) -> base <> " " <> duration_value(d)
      }
    }
  }
}

fn transitions_last_write_wins(
  transitions: List(Transition),
) -> List(Transition) {
  // Keep only the last transition for each property.
  let #(kept, _) =
    list.fold_right(transitions, #([], []), fn(acc, transition) {
      let #(kept, seen) = acc
      let key = transition_key(transition)

      case list.contains(seen, key) {
        True -> #(kept, seen)
        False -> #([transition, ..kept], [key, ..seen])
      }
    })

  kept
}

fn sort_transitions(transitions: List(Transition)) -> List(Transition) {
  list.sort(transitions, by: fn(a, b) {
    string.compare(transition_key(a), transition_key(b))
  })
}

/// Set one or more CSS transitions.
///
/// Transitions are canonicalized to be order-independent:
/// - last write wins for duplicate properties
/// - unique transitions are sorted by property name
pub fn transitions(transitions transitions: List(Transition)) -> Attribute {
  let normalized =
    transitions
    |> transitions_last_write_wins
    |> sort_transitions

  let value = case normalized {
    [] -> "none"
    _ ->
      normalized
      |> list.map(transition_to_string)
      |> string.join(with: ", ")
  }

  attr(
    rule_from_declarations([
      Declaration(property: "transition", value: value),
    ]),
  )
}

/// Convenience: set a single transition.
pub fn transition(
  property property: TransitionProperty,
  duration duration: Duration,
  easing easing: Easing,
) -> Attribute {
  transitions(transitions: [transition_item(property:, duration:, easing:)])
}

/// Convenience: set a single transition with an explicit delay.
pub fn transition_with_delay(
  property property: TransitionProperty,
  duration duration: Duration,
  easing easing: Easing,
  delay delay: Duration,
) -> Attribute {
  transitions(transitions: [
    transition_item_with_delay(property:, duration:, easing:, delay:),
  ])
}

/// Set the opacity (`0` to `1`) for an element.
///
/// Values are clamped to `[0, 1]`.
pub fn alpha(opacity opacity: Float) -> Attribute {
  let value = clamp_float(opacity, min: 0.0, max: 1.0)
  attr(
    rule_from_declarations([
      Declaration(property: "opacity", value: normalize_float_string(value, 4)),
    ]),
  )
}

/// Hide an element but keep its layout space.
pub fn hidden() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "visibility", value: "hidden"),
    ]),
  )
}

/// Remove an element from layout.
pub fn display_none() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "display", value: "none"),
    ]),
  )
}

/// Visually hide an element while keeping it available to assistive technology.
pub fn visually_hidden() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "position", value: "absolute"),
      Declaration(property: "width", value: "1px"),
      Declaration(property: "height", value: "1px"),
      Declaration(property: "padding", value: "0"),
      Declaration(property: "margin", value: "-1px"),
      Declaration(property: "overflow", value: "hidden"),
      Declaration(property: "clip", value: "rect(0 0 0 0)"),
      Declaration(property: "white-space", value: "nowrap"),
      Declaration(property: "border", value: "0"),
    ]),
  )
}

/// Set the CSS `position` for an element.
pub fn position(value value: Position) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "position", value: position_value(value)),
    ]),
  )
}

/// Set the `top` offset for a positioned element.
pub fn top(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "top", value: css_length_value(length)),
    ]),
  )
}

/// Set the `right` offset for a positioned element.
pub fn right(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "right", value: css_length_value(length)),
    ]),
  )
}

/// Set the `bottom` offset for a positioned element.
pub fn bottom(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "bottom", value: css_length_value(length)),
    ]),
  )
}

/// Set the `left` offset for a positioned element.
pub fn left(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "left", value: css_length_value(length)),
    ]),
  )
}

/// Set all four offsets (`top/right/bottom/left`) to the same value.
pub fn inset(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "top", value: css_length_value(length)),
      Declaration(property: "right", value: css_length_value(length)),
      Declaration(property: "bottom", value: css_length_value(length)),
      Declaration(property: "left", value: css_length_value(length)),
    ]),
  )
}

/// Set horizontal (`left/right`) and vertical (`top/bottom`) offsets.
pub fn inset_xy(x x: CssLength, y y: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "left", value: css_length_value(x)),
      Declaration(property: "right", value: css_length_value(x)),
      Declaration(property: "top", value: css_length_value(y)),
      Declaration(property: "bottom", value: css_length_value(y)),
    ]),
  )
}

/// Set the `justify-content` value for a flex or grid container.
pub fn justify_content(value value: JustifyContent) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "justify-content",
        value: justify_content_value(value),
      ),
    ]),
  )
}

/// Set the `align-items` value for a flex or grid container.
pub fn align_items(value value: AlignItems) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "align-items", value: align_items_value(value)),
    ]),
  )
}

/// Set the `flex-wrap` value for a flex container.
pub fn flex_wrap(value value: FlexWrap) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "flex-wrap", value: flex_wrap_value(value)),
    ]),
  )
}

/// Set the CSS `display` value for an element.
pub fn display(value value: Display) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "display", value: display_value(value)),
    ]),
  )
}

/// Set the `vertical-align` value for an element.
pub fn vertical_align(value value: VerticalAlign) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "vertical-align",
        value: vertical_align_value(value),
      ),
    ]),
  )
}

/// Set a transform on an element.
///
/// An empty list renders `transform:none`.
pub fn transform(items items: List(TransformItem)) -> Attribute {
  let value = case items {
    [] -> "none"
    _ ->
      items
      |> list.map(transform_item_value)
      |> string.join(with: " ")
  }

  attr(
    rule_from_declarations([
      Declaration(property: "transform", value: value),
    ]),
  )
}

/// Set the `text-decoration` value for an element.
pub fn text_decoration(value value: TextDecoration) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "text-decoration",
        value: text_decoration_value(value),
      ),
    ]),
  )
}

/// Set the `user-select` value for an element.
pub fn user_select(value value: UserSelect) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "user-select", value: user_select_value(value)),
    ]),
  )
}

/// Set the `appearance` value for an element (where supported).
pub fn appearance(value value: Appearance) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "appearance", value: appearance_value(value)),
    ]),
  )
}

/// Set the cursor for an element.
pub fn cursor(cursor cursor: Cursor) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "cursor", value: cursor_value(cursor)),
    ]),
  )
}

/// Set `pointer-events` for an element.
pub fn pointer_events(value value: PointerEvents) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "pointer-events",
        value: pointer_events_value(value),
      ),
    ]),
  )
}

/// Set the overflow behavior for an element.
pub fn overflow(overflow overflow: Overflow) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "overflow", value: overflow_value(overflow)),
    ]),
  )
}

/// Set the horizontal overflow behavior for an element.
pub fn overflow_x(overflow overflow: Overflow) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "overflow-x", value: overflow_value(overflow)),
    ]),
  )
}

/// Set the vertical overflow behavior for an element.
pub fn overflow_y(overflow overflow: Overflow) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "overflow-y", value: overflow_value(overflow)),
    ]),
  )
}

/// Convenience: enable horizontal scrolling (`overflow-x: auto`).
pub fn scroll_x() -> Attribute {
  overflow_x(overflow: overflow_auto())
}

/// Convenience: enable vertical scrolling (`overflow-y: auto`).
pub fn scroll_y() -> Attribute {
  overflow_y(overflow: overflow_auto())
}

/// Convenience: enable scrolling on both axes (`overflow: auto`).
pub fn scroll_both() -> Attribute {
  overflow(overflow: overflow_auto())
}

/// Set the overscroll behavior.
pub fn overscroll_behavior(value value: OverscrollBehavior) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "overscroll-behavior",
        value: overscroll_behavior_value(value),
      ),
    ]),
  )
}

/// Set the horizontal overscroll behavior.
pub fn overscroll_behavior_x(value value: OverscrollBehavior) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "overscroll-behavior-x",
        value: overscroll_behavior_value(value),
      ),
    ]),
  )
}

/// Set the vertical overscroll behavior.
pub fn overscroll_behavior_y(value value: OverscrollBehavior) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "overscroll-behavior-y",
        value: overscroll_behavior_value(value),
      ),
    ]),
  )
}

/// Set the scrollbar gutter behavior.
pub fn scrollbar_gutter(gutter gutter: ScrollbarGutter) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "scrollbar-gutter",
        value: scrollbar_gutter_value(gutter),
      ),
    ]),
  )
}

/// Set the scrollbar width (where supported).
pub fn scrollbar_width(width width: ScrollbarWidth) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "scrollbar-width",
        value: scrollbar_width_value(width),
      ),
    ]),
  )
}

/// Set the scrollbar colors (where supported).
pub fn scrollbar_color(thumb thumb: Color, track track: Color) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "scrollbar-color",
        value: color_value(thumb) <> " " <> color_value(track),
      ),
    ]),
  )
}

/// Set the scroll behavior (for example smooth scrolling).
pub fn scroll_behavior(behavior behavior: ScrollBehavior) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "scroll-behavior",
        value: scroll_behavior_value(behavior),
      ),
    ]),
  )
}

/// Enable inline-size container query behavior.
pub fn container_inline_size() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "container-type", value: "inline-size"),
    ]),
  )
}

/// Set the container name used by named `@container` rules.
pub fn container_name(value value: String) -> Attribute {
  let normalized = case string.trim(value) {
    "" -> "container"
    name -> name
  }

  attr(
    rule_from_declarations([
      Declaration(property: "container-name", value: normalized),
    ]),
  )
}

/// Set the scroll snap type for a scroll container.
pub fn scroll_snap_type(value value: ScrollSnapType) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "scroll-snap-type",
        value: scroll_snap_type_value(value),
      ),
    ]),
  )
}

/// Set scroll snap alignment for a scroll item.
pub fn scroll_snap_align(value value: ScrollSnapAlign) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "scroll-snap-align",
        value: scroll_snap_align_value(value),
      ),
    ]),
  )
}

fn clamp_int_min_1(value: Int) -> Int {
  case value < 1 {
    True -> 1
    False -> value
  }
}

/// Set an element's aspect ratio.
///
/// Width and height are clamped to be at least `1`.
pub fn aspect_ratio(width width: Int, height height: Int) -> Attribute {
  let w = clamp_int_min_1(width)
  let h = clamp_int_min_1(height)

  attr(
    rule_from_declarations([
      Declaration(
        property: "aspect-ratio",
        value: int.to_string(w) <> " / " <> int.to_string(h),
      ),
    ]),
  )
}

/// Set `aspect-ratio: auto`.
pub fn aspect_ratio_auto() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "aspect-ratio", value: "auto"),
    ]),
  )
}

/// Set `object-fit` for replaced content (for example images).
pub fn object_fit(fit fit: ObjectFit) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "object-fit", value: object_fit_value(fit)),
    ]),
  )
}

/// Sensible defaults for images.
///
/// Intended for use by renderer-layer image primitives.
pub fn image_layout() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "display", value: "block"),
      Declaration(property: "max-width", value: "100%"),
      Declaration(property: "height", value: "auto"),
    ]),
  )
}

fn join_grid_tracks(tracks: List(GridTrack)) -> String {
  case tracks {
    [] -> "none"
    _ ->
      tracks
      |> list.map(grid_track_value)
      |> string.join(with: " ")
  }
}

/// Set grid template columns.
pub fn grid_columns(tracks tracks: List(GridTrack)) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "grid-template-columns",
        value: join_grid_tracks(tracks),
      ),
    ]),
  )
}

/// Set grid template rows.
pub fn grid_rows(tracks tracks: List(GridTrack)) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "grid-template-rows",
        value: join_grid_tracks(tracks),
      ),
    ]),
  )
}

/// Set the grid auto flow mode.
pub fn grid_auto_flow(flow flow: GridAutoFlow) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "grid-auto-flow", value: grid_auto_flow_value(flow)),
    ]),
  )
}

/// Place an item on grid columns.
///
/// `start` and `span` are clamped to be at least `1`.
pub fn grid_column(start start: Int, span span: Int) -> Attribute {
  let s = clamp_int_min_1(start)
  let sp = clamp_int_min_1(span)

  attr(
    rule_from_declarations([
      Declaration(
        property: "grid-column",
        value: int.to_string(s) <> " / span " <> int.to_string(sp),
      ),
    ]),
  )
}

/// Place an item on grid rows.
///
/// `start` and `span` are clamped to be at least `1`.
pub fn grid_row(start start: Int, span span: Int) -> Attribute {
  let s = clamp_int_min_1(start)
  let sp = clamp_int_min_1(span)

  attr(
    rule_from_declarations([
      Declaration(
        property: "grid-row",
        value: int.to_string(s) <> " / span " <> int.to_string(sp),
      ),
    ]),
  )
}

/// Set the `font-family` for an element.
pub fn font_family(families families: List(FontFamily)) -> Attribute {
  let value = case families {
    [] -> "inherit"
    _ ->
      families
      |> list.map(font_family_value)
      |> string.join(with: ", ")
  }

  attr(
    rule_from_declarations([
      Declaration(property: "font-family", value: value),
    ]),
  )
}

/// Set the `font-size` for an element.
pub fn font_size(size size: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "font-size", value: css_length_value(size)),
    ]),
  )
}

/// Set the `font-weight` for an element.
pub fn font_weight(weight weight: FontWeight) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "font-weight", value: font_weight_css(weight)),
    ]),
  )
}

/// Set the `line-height` for an element.
pub fn line_height(height height: LineHeight) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "line-height", value: line_height_value(height)),
    ]),
  )
}

/// Set the `letter-spacing` for an element.
pub fn letter_spacing(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "letter-spacing", value: css_length_value(length)),
    ]),
  )
}

/// Set the `text-align` for an element.
pub fn text_align(align align: TextAlign) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "text-align", value: text_align_value(align)),
    ]),
  )
}

/// Set the `white-space` behavior for an element.
pub fn white_space(value value: WhiteSpace) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "white-space", value: white_space_value(value)),
    ]),
  )
}

/// Set the `text-overflow` behavior for an element.
///
/// Typically combined with `white_space(white_space_nowrap())` and
/// `overflow(overflow_hidden())` for ellipsis truncation.
pub fn text_overflow(value value: TextOverflow) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "text-overflow", value: text_overflow_value(value)),
    ]),
  )
}

/// Set the `text-transform` for an element.
pub fn text_transform(value value: TextTransform) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "text-transform",
        value: text_transform_value(value),
      ),
    ]),
  )
}

/// Set the `word-break` behavior for an element.
pub fn word_break(value value: WordBreak) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "word-break", value: word_break_value(value)),
    ]),
  )
}

/// Set the `overflow-wrap` behavior for an element.
pub fn overflow_wrap(value value: OverflowWrap) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "overflow-wrap", value: overflow_wrap_value(value)),
    ]),
  )
}

/// Set the `color-scheme` for an element (affects native control theming).
pub fn color_scheme(scheme scheme: ColorScheme) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "color-scheme", value: color_scheme_value(scheme)),
    ]),
  )
}

/// Apply CSS `filter` effects to an element.
///
/// An empty list renders `filter: none`.
pub fn filter(filters filters: List(Filter)) -> Attribute {
  let value = case filters {
    [] -> "none"
    _ ->
      filters
      |> list.map(filter_value)
      |> string.join(with: " ")
  }
  attr(rule_from_declarations([Declaration(property: "filter", value: value)]))
}

/// Apply CSS `backdrop-filter` effects to an element's backdrop.
///
/// An empty list renders `backdrop-filter: none`.
pub fn backdrop_filter(filters filters: List(Filter)) -> Attribute {
  let value = case filters {
    [] -> "none"
    _ ->
      filters
      |> list.map(filter_value)
      |> string.join(with: " ")
  }
  attr(
    rule_from_declarations([
      Declaration(property: "backdrop-filter", value: value),
    ]),
  )
}

/// Set the `order` of a flex or grid item.
pub fn order(value value: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "order", value: int.to_string(value)),
    ]),
  )
}

/// Round the corners of an element using `border-radius`.
pub fn rounded(radius radius: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "border-radius", value: css_length_value(radius)),
    ]),
  )
}

/// Round the top-left corner of an element.
pub fn rounded_top_left(radius radius: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "border-top-left-radius",
        value: css_length_value(radius),
      ),
    ]),
  )
}

/// Round the top-right corner of an element.
pub fn rounded_top_right(radius radius: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "border-top-right-radius",
        value: css_length_value(radius),
      ),
    ]),
  )
}

/// Round the bottom-left corner of an element.
pub fn rounded_bottom_left(radius radius: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "border-bottom-left-radius",
        value: css_length_value(radius),
      ),
    ]),
  )
}

/// Round the bottom-right corner of an element.
pub fn rounded_bottom_right(radius radius: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "border-bottom-right-radius",
        value: css_length_value(radius),
      ),
    ]),
  )
}

/// Set a border using the CSS `border` shorthand.
pub fn border(
  width width: CssLength,
  style style: BorderStyle,
  color color: Color,
) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "border",
        value: css_length_value(width)
          <> " "
          <> border_style_value(style)
          <> " "
          <> color_value(color),
      ),
    ]),
  )
}

fn shadow_to_string(shadow: Shadow) -> String {
  case shadow {
    Shadow(inset:, x:, y:, blur:, spread:, color:) -> {
      let prefix = case inset {
        True -> "inset "
        False -> ""
      }

      prefix
      <> css_length_value(x)
      <> " "
      <> css_length_value(y)
      <> " "
      <> css_length_value(blur)
      <> " "
      <> css_length_value(spread)
      <> " "
      <> color_value(color)
    }
  }
}

/// Set the `box-shadow` for an element.
pub fn shadows(shadows shadows: List(Shadow)) -> Attribute {
  let value = case shadows {
    [] -> "none"
    _ ->
      shadows
      |> list.map(shadow_to_string)
      |> string.join(with: ", ")
  }

  attr(
    rule_from_declarations([
      Declaration(property: "box-shadow", value: value),
    ]),
  )
}

/// Set an outline using `solid` style.
///
/// This is intended for focus indicators without shifting layout.
pub fn outline(width width: CssLength, color color: Color) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "outline",
        value: css_length_value(width) <> " solid " <> color_value(color),
      ),
    ]),
  )
}

/// Set the outline offset.
pub fn outline_offset(length length: CssLength) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "outline-offset", value: css_length_value(length)),
    ]),
  )
}

/// Remove the outline.
pub fn outline_none() -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "outline", value: "none"),
    ]),
  )
}

fn rule_from_attrs(attrs: List(Attribute)) -> Rule {
  attrs
  |> list.map(attribute_rule)
  |> list.fold(rule_empty(), rule_merge)
}

fn pseudo(pseudo: String, attrs: List(Attribute)) -> Attribute {
  let nested = rule_from_attrs(attrs)
  attr(
    Rule(
      declarations: [],
      pseudos: [#(pseudo, nested)],
      medias: [],
      containers: [],
      ancestors: [],
      extra_classes: [],
    ),
  )
}

fn media(query: String, attrs: List(Attribute)) -> Attribute {
  let nested = rule_from_attrs(attrs)
  attr(
    Rule(
      declarations: [],
      pseudos: [],
      medias: [#(query, nested)],
      containers: [],
      ancestors: [],
      extra_classes: [],
    ),
  )
}

fn container(query: String, attrs: List(Attribute)) -> Attribute {
  let nested = rule_from_attrs(attrs)
  attr(
    Rule(
      declarations: [],
      pseudos: [],
      medias: [],
      containers: [#(query, nested)],
      ancestors: [],
      extra_classes: [],
    ),
  )
}

fn ancestor_pseudo(
  ancestor_class: String,
  pseudo_name: String,
  attrs: List(Attribute),
) -> Attribute {
  let nested = rule_from_attrs(attrs)
  let key = "." <> ancestor_class <> ":" <> pseudo_name <> " "
  attr(
    Rule(
      declarations: [],
      pseudos: [],
      medias: [],
      containers: [],
      ancestors: [#(key, nested)],
      extra_classes: [],
    ),
  )
}

/// Apply attributes within a media query (`@media ...`).
pub fn when(query query: MediaQuery, attrs attrs: List(Attribute)) -> Attribute {
  media(media_query_value(query), attrs)
}

/// Apply attributes within a container query (`@container ...`).
pub fn when_container(
  query query: ContainerQuery,
  attrs attrs: List(Attribute),
) -> Attribute {
  container(container_query_value(query), attrs)
}

/// Apply attributes on mouse hover (`:hover`).
pub fn mouse_over(attrs attrs: List(Attribute)) -> Attribute {
  pseudo("hover", attrs)
}

/// Apply attributes when focused (`:focus`).
pub fn focused(attrs attrs: List(Attribute)) -> Attribute {
  pseudo("focus", attrs)
}

/// Apply attributes when active (`:active`).
pub fn active(attrs attrs: List(Attribute)) -> Attribute {
  pseudo("active", attrs)
}

/// Apply attributes when disabled (`:disabled`).
pub fn disabled(attrs attrs: List(Attribute)) -> Attribute {
  pseudo("disabled", attrs)
}

/// Apply attributes when focus is visible (`:focus-visible`).
pub fn focus_visible(attrs attrs: List(Attribute)) -> Attribute {
  pseudo("focus-visible", attrs)
}

/// Apply attributes when focus is within (`:focus-within`).
pub fn focus_within(attrs attrs: List(Attribute)) -> Attribute {
  pseudo("focus-within", attrs)
}

fn group_static_class(name: String) -> String {
  "weft-group-" <> name
}

/// Mark this element as a hover group anchor with the given name.
///
/// Adds the static CSS class `weft-group-<name>` to the element.
/// Use `group_hover` on descendant elements to respond when this ancestor
/// is hovered.
pub fn group(name name: String) -> Attribute {
  class_name_attr(group_static_class(name))
}

fn class_name_attr(static_class: String) -> Attribute {
  attr(
    Rule(
      declarations: [],
      pseudos: [],
      medias: [],
      containers: [],
      ancestors: [],
      extra_classes: [static_class],
    ),
  )
}

/// Apply attrs when an ancestor marked with `group(name:)` is hovered.
///
/// Generates CSS: `.weft-group-<name>:hover .<class> { ... }`
pub fn group_hover(
  group group: String,
  attrs attrs: List(Attribute),
) -> Attribute {
  ancestor_pseudo(group_static_class(group), "hover", attrs)
}

/// Apply margin to all sides.
pub fn margin(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin", value: int.to_string(pixels) <> "px"),
    ]),
  )
}

/// Apply horizontal and vertical margin.
///
/// `x` is left/right, `y` is top/bottom.
pub fn margin_xy(x x: Int, y y: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "margin",
        value: int.to_string(y) <> "px " <> int.to_string(x) <> "px",
      ),
    ]),
  )
}

/// Apply top margin only.
pub fn margin_top(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-top", value: int.to_string(pixels) <> "px"),
    ]),
  )
}

/// Apply bottom margin only.
pub fn margin_bottom(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "margin-bottom",
        value: int.to_string(pixels) <> "px",
      ),
    ]),
  )
}

/// Apply left margin only.
pub fn margin_left(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(property: "margin-left", value: int.to_string(pixels) <> "px"),
    ]),
  )
}

/// Apply right margin only.
pub fn margin_right(pixels pixels: Int) -> Attribute {
  attr(
    rule_from_declarations([
      Declaration(
        property: "margin-right",
        value: int.to_string(pixels) <> "px",
      ),
    ]),
  )
}

/// A named responsive breakpoint for use with `hide_below`/`show_below`.
pub type Breakpoint {
  /// Below 768px — phone portrait and smaller.
  MobileBreakpoint
  /// Below 1024px — tablet and small laptop.
  TabletBreakpoint
}

/// Hide this element below the given breakpoint (`display: none` in media query).
pub fn hide_below(breakpoint breakpoint: Breakpoint) -> Attribute {
  case breakpoint {
    MobileBreakpoint ->
      when(query: max_width(length: px(pixels: 767)), attrs: [display_none()])
    TabletBreakpoint ->
      when(query: max_width(length: px(pixels: 1023)), attrs: [display_none()])
  }
}

/// Show this element only below the given breakpoint.
///
/// The element is hidden above the breakpoint via this attribute.
pub fn show_below(breakpoint breakpoint: Breakpoint) -> Attribute {
  case breakpoint {
    MobileBreakpoint ->
      when(query: min_width(length: px(pixels: 768)), attrs: [display_none()])
    TabletBreakpoint ->
      when(query: min_width(length: px(pixels: 1024)), attrs: [display_none()])
  }
}

fn attribute_rule(attribute: Attribute) -> Rule {
  case attribute {
    Attribute(rule:) -> rule
  }
}

fn fnv1a_32(input: String) -> Int {
  let offset_basis = 2_166_136_261
  let prime = 16_777_619

  input
  |> string.to_utf_codepoints
  |> list.map(string.utf_codepoint_to_int)
  |> list.fold(offset_basis, fn(hash, codepoint) {
    // Hash input is expected to be ASCII. Mask to keep 32-bit semantics.
    let byte = int.bitwise_and(codepoint, 255)
    let next = int.bitwise_exclusive_or(hash, byte)
    mul32(next, prime)
  })
}

fn mul32(a: Int, b: Int) -> Int {
  // 32-bit multiplication modulo 2^32 without overflowing JS safe integers.
  // This matches the semantics of C-style uint32 multiplication.
  let mask_16 = 65_535
  let mask_32 = 4_294_967_295

  let a_low = int.bitwise_and(a, mask_16)
  let a_high = int.bitwise_shift_right(a, 16)
  let b_low = int.bitwise_and(b, mask_16)
  let b_high = int.bitwise_shift_right(b, 16)

  let low = a_low * b_low
  let mid = a_high * b_low + a_low * b_high

  int.bitwise_and(low + int.bitwise_shift_left(mid, 16), mask_32)
}

fn to_lower_hex_8(value: Int) -> String {
  let digits = "0123456789abcdef"

  to_lower_hex_8_loop(value, "", 0, digits)
}

fn to_lower_hex_8_loop(
  remaining: Int,
  out: String,
  count: Int,
  digits: String,
) -> String {
  case count {
    8 -> out
    _ -> {
      let shifted = int.bitwise_shift_right(remaining, 4)
      let nibble = int.bitwise_and(remaining, 15)
      let char = case string.slice(digits, nibble, 1) {
        "" -> "0"
        s -> s
      }
      to_lower_hex_8_loop(shifted, char <> out, count + 1, digits)
    }
  }
}

fn rule_to_css(selector: String, rule: Rule) -> String {
  case rule {
    Rule(
      declarations:,
      pseudos:,
      medias:,
      containers:,
      ancestors:,
      extra_classes: _,
    ) -> {
      let base = case declarations {
        [] -> ""
        _ -> selector <> "{" <> declarations_to_css(declarations) <> "}\n"
      }

      let pseudo_css =
        pseudos
        |> list.map(fn(pair) {
          case pair {
            #(pseudo, nested) -> rule_to_css(selector <> ":" <> pseudo, nested)
          }
        })
        |> string.concat

      let media_css =
        medias
        |> list.map(fn(pair) {
          case pair {
            #(query, nested) ->
              "@media "
              <> query
              <> "{\n"
              <> rule_to_css(selector, nested)
              <> "}\n"
          }
        })
        |> string.concat

      let container_css =
        containers
        |> list.map(fn(pair) {
          case pair {
            #(query, nested) ->
              "@container "
              <> query
              <> "{\n"
              <> rule_to_css(selector, nested)
              <> "}\n"
          }
        })
        |> string.concat

      let ancestor_css =
        ancestors
        |> list.map(fn(pair) {
          case pair {
            #(ancestor_selector, nested) ->
              rule_to_css(ancestor_selector <> selector, nested)
          }
        })
        |> string.concat

      base <> pseudo_css <> media_css <> container_css <> ancestor_css
    }
  }
}

fn declarations_to_css(declarations: List(Declaration)) -> String {
  declarations
  |> list.map(fn(decl) {
    case decl {
      Declaration(property:, value:) -> property <> ":" <> value <> ";"
    }
  })
  |> string.concat
}

/// Build a deterministic `Class` from a list of `Attribute`s.
pub fn class(attrs attrs: List(Attribute)) -> Class {
  let merged =
    attrs
    |> list.map(attribute_rule)
    |> list.fold(rule_empty(), rule_merge)
    |> rule_normalize

  let extra_classes = case merged {
    Rule(extra_classes:, ..) -> extra_classes
  }

  let serialized = rule_to_css(".x", merged)
  let hash = fnv1a_32(serialized)
  let name = "wf-" <> to_lower_hex_8(hash)

  Class(name: name, rule: merged, extra_classes: extra_classes)
}

/// Get the deterministic class name (for example `wf-deadbeef`).
pub fn class_name(class class: Class) -> String {
  case class {
    Class(name:, rule: _, extra_classes: _) -> name
  }
}

/// Get any extra static CSS class names attached to this class.
///
/// Used by renderers to apply additional classes (for example `weft-group-<name>`)
/// beyond the single deterministic hash-based class name.
pub fn class_extra_names(class class: Class) -> List(String) {
  case class {
    Class(name: _, rule: _, extra_classes:) -> extra_classes
  }
}

fn class_css(class: Class) -> String {
  case class {
    Class(name:, rule:, extra_classes: _) -> rule_to_css("." <> name, rule)
  }
}

fn dedupe_sorted_classes(classes: List(Class)) -> List(Class) {
  case classes {
    [] -> []
    [first, ..rest] -> {
      let #(kept_rev, _) =
        list.fold(rest, #([first], first), fn(acc, next) {
          let #(kept_rev, last) = acc
          case class_name(class: next) == class_name(class: last) {
            True -> #(kept_rev, last)
            False -> #([next, ..kept_rev], next)
          }
        })

      list.reverse(kept_rev)
    }
  }
}

/// Render a deterministic CSS stylesheet for the given classes.
pub fn stylesheet(classes classes: List(Class)) -> String {
  let sorted =
    list.sort(classes, by: fn(a, b) {
      string.compare(class_name(class: a), class_name(class: b))
    })

  sorted
  |> dedupe_sorted_classes
  |> list.map(class_css)
  |> string.concat
}

/// Return a human-readable explanation of a class (for debugging and tests).
pub fn inspect_class(class class: Class) -> String {
  "Class " <> class_name(class: class) <> "\n" <> class_css(class)
}
