//// Internal anchored overlay micro-solver implementation.
////
//// This module is `@internal` and is not part of the stable public API. The
//// stable API is exposed from `weft.gleam`.

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import weft/internal/geometry

/// The side of an overlay relative to its anchor.
@internal
pub type OverlaySide {
  Above
  Below
  Left
  Right
}

/// The alignment of an overlay on its cross-axis.
@internal
pub type OverlayAlign {
  Start
  Center
  End
}

/// A placement (side + alignment).
@internal
pub type OverlayPlacement {
  OverlayPlacement(side: OverlaySide, align: OverlayAlign)
}

/// The input problem for anchored overlay solving.
@internal
pub type OverlayProblem {
  OverlayProblem(
    anchor: geometry.Rect,
    overlay: geometry.Size,
    viewport: geometry.Rect,
    prefer_sides: List(OverlaySide),
    alignments: List(OverlayAlign),
    offset: Int,
    padding: Int,
    arrow: Option(#(Int, Int)),
  )
}

/// The output solution for anchored overlay solving.
@internal
pub type OverlaySolution {
  OverlaySolution(
    placement: OverlayPlacement,
    x: Int,
    y: Int,
    arrow_x: Option(Int),
    arrow_y: Option(Int),
  )
}

fn clamp_non_negative_int(value: Int) -> Int {
  case value < 0 {
    True -> 0
    False -> value
  }
}

fn max_int(a: Int, b: Int) -> Int {
  case a >= b {
    True -> a
    False -> b
  }
}

fn clamp_int(value value: Int, min min: Int, max max: Int) -> Int {
  case value < min {
    True -> min
    False ->
      case value > max {
        True -> max
        False -> value
      }
  }
}

fn default_prefer_sides() -> List(OverlaySide) {
  [Below, Above, Right, Left]
}

fn default_alignments() -> List(OverlayAlign) {
  [Center, Start, End]
}

/// Construct a side representing "above".
@internal
pub fn overlay_side_above() -> OverlaySide {
  Above
}

/// Construct a side representing "below".
@internal
pub fn overlay_side_below() -> OverlaySide {
  Below
}

/// Construct a side representing "left".
@internal
pub fn overlay_side_left() -> OverlaySide {
  Left
}

/// Construct a side representing "right".
@internal
pub fn overlay_side_right() -> OverlaySide {
  Right
}

/// Construct an alignment representing "start".
@internal
pub fn overlay_align_start() -> OverlayAlign {
  Start
}

/// Construct an alignment representing "center".
@internal
pub fn overlay_align_center() -> OverlayAlign {
  Center
}

/// Construct an alignment representing "end".
@internal
pub fn overlay_align_end() -> OverlayAlign {
  End
}

/// Construct a placement.
@internal
pub fn overlay_placement(
  side side: OverlaySide,
  align align: OverlayAlign,
) -> OverlayPlacement {
  OverlayPlacement(side: side, align: align)
}

/// Get the side of a placement.
@internal
pub fn overlay_placement_side(
  placement placement: OverlayPlacement,
) -> OverlaySide {
  case placement {
    OverlayPlacement(side:, ..) -> side
  }
}

/// Get the alignment of a placement.
@internal
pub fn overlay_placement_align(
  placement placement: OverlayPlacement,
) -> OverlayAlign {
  case placement {
    OverlayPlacement(align:, ..) -> align
  }
}

/// Construct a default overlay problem.
@internal
pub fn overlay_problem(
  anchor anchor: geometry.Rect,
  overlay overlay: geometry.Size,
  viewport viewport: geometry.Rect,
) -> OverlayProblem {
  OverlayProblem(
    anchor: anchor,
    overlay: overlay,
    viewport: viewport,
    prefer_sides: default_prefer_sides(),
    alignments: default_alignments(),
    offset: 0,
    padding: 0,
    arrow: None,
  )
}

/// Set the preferred side order for a problem.
///
/// Passing an empty list resets to the default order.
@internal
pub fn overlay_prefer_sides(
  problem problem: OverlayProblem,
  sides sides: List(OverlaySide),
) -> OverlayProblem {
  case sides {
    [] -> OverlayProblem(..problem, prefer_sides: default_prefer_sides())
    sides -> OverlayProblem(..problem, prefer_sides: sides)
  }
}

/// Set the allowed alignments for a problem.
///
/// Passing an empty list resets to the default order.
@internal
pub fn overlay_alignments(
  problem problem: OverlayProblem,
  aligns aligns: List(OverlayAlign),
) -> OverlayProblem {
  case aligns {
    [] -> OverlayProblem(..problem, alignments: default_alignments())
    aligns -> OverlayProblem(..problem, alignments: aligns)
  }
}

/// Set the overlay-to-anchor offset in pixels.
///
/// Negative values are clamped to `0`.
@internal
pub fn overlay_offset(
  problem problem: OverlayProblem,
  pixels pixels: Int,
) -> OverlayProblem {
  OverlayProblem(..problem, offset: clamp_non_negative_int(pixels))
}

/// Set the viewport padding used for safe placement.
///
/// Negative values are clamped to `0`.
@internal
pub fn overlay_padding(
  problem problem: OverlayProblem,
  pixels pixels: Int,
) -> OverlayProblem {
  OverlayProblem(..problem, padding: clamp_non_negative_int(pixels))
}

/// Enable arrow output.
///
/// Sizes are clamped to be non-negative.
@internal
pub fn overlay_arrow(
  problem problem: OverlayProblem,
  size_px size_px: Int,
  edge_padding_px edge_padding_px: Int,
) -> OverlayProblem {
  OverlayProblem(
    ..problem,
    arrow: Some(#(
      clamp_non_negative_int(size_px),
      clamp_non_negative_int(edge_padding_px),
    )),
  )
}

/// Solve an overlay problem.
@internal
pub fn solve_overlay(problem problem: OverlayProblem) -> OverlaySolution {
  case problem {
    OverlayProblem(
      anchor: anchor,
      overlay: overlay,
      viewport: viewport,
      prefer_sides: prefer_sides,
      alignments: alignments,
      offset: offset,
      padding: padding,
      arrow: arrow,
    ) -> {
      let safe_viewport =
        geometry.rect_inset(
          viewport,
          left: padding,
          top: padding,
          right: padding,
          bottom: padding,
        )

      let safe_left = geometry.rect_x(safe_viewport)
      let safe_top = geometry.rect_y(safe_viewport)
      let safe_right = geometry.rect_right(safe_viewport)
      let safe_bottom = geometry.rect_bottom(safe_viewport)

      let overlay_w = geometry.size_width(overlay)
      let overlay_h = geometry.size_height(overlay)
      let anchor_cx = geometry.rect_center_x(anchor)
      let anchor_cy = geometry.rect_center_y(anchor)

      let best =
        list.fold(prefer_sides, None, fn(best, side) {
          list.fold(alignments, best, fn(best, align) {
            let placement = OverlayPlacement(side: side, align: align)

            let #(x0, y0) =
              candidate_xy(
                placement,
                anchor,
                overlay_w,
                overlay_h,
                offset,
                anchor_cx,
                anchor_cy,
              )

            let x_clamped =
              clamp_with_oversize(
                value: x0,
                min: safe_left,
                max: safe_right - overlay_w,
                oversize_fallback: safe_left,
              )

            let y_clamped =
              clamp_with_oversize(
                value: y0,
                min: safe_top,
                max: safe_bottom - overlay_h,
                oversize_fallback: safe_top,
              )

            let overflow =
              overflow_total(
                x_clamped,
                y_clamped,
                overlay_w,
                overlay_h,
                safe_left,
                safe_top,
                safe_right,
                safe_bottom,
              )

            let shift =
              int.absolute_value(x_clamped - x0)
              + int.absolute_value(y_clamped - y0)

            let candidate =
              Candidate(
                placement: placement,
                x: x_clamped,
                y: y_clamped,
                overflow: overflow,
                shift: shift,
              )

            case best {
              None -> Some(candidate)
              Some(best) ->
                case candidate_better(candidate, best) {
                  True -> Some(candidate)
                  False -> Some(best)
                }
            }
          })
        })

      let chosen = case best {
        None ->
          Candidate(
            placement: OverlayPlacement(side: Below, align: Center),
            x: safe_left,
            y: safe_top,
            overflow: 0,
            shift: 0,
          )
        Some(c) -> c
      }

      let #(arrow_x, arrow_y) =
        compute_arrow(
          arrow: arrow,
          placement: chosen.placement,
          anchor_cx: anchor_cx,
          anchor_cy: anchor_cy,
          x: chosen.x,
          y: chosen.y,
          overlay_w: overlay_w,
          overlay_h: overlay_h,
        )

      OverlaySolution(
        placement: chosen.placement,
        x: chosen.x,
        y: chosen.y,
        arrow_x: arrow_x,
        arrow_y: arrow_y,
      )
    }
  }
}

type Candidate {
  Candidate(
    placement: OverlayPlacement,
    x: Int,
    y: Int,
    overflow: Int,
    shift: Int,
  )
}

fn candidate_better(a: Candidate, b: Candidate) -> Bool {
  case a.overflow < b.overflow {
    True -> True
    False ->
      case a.overflow > b.overflow {
        True -> False
        False -> a.shift < b.shift
      }
  }
}

fn clamp_with_oversize(
  value value: Int,
  min min: Int,
  max max: Int,
  oversize_fallback oversize_fallback: Int,
) -> Int {
  case max < min {
    True -> oversize_fallback
    False -> clamp_int(value, min: min, max: max)
  }
}

fn overflow_total(
  x: Int,
  y: Int,
  w: Int,
  h: Int,
  safe_left: Int,
  safe_top: Int,
  safe_right: Int,
  safe_bottom: Int,
) -> Int {
  let overflow_left = max_int(safe_left - x, 0)
  let overflow_top = max_int(safe_top - y, 0)
  let overflow_right = max_int({ x + w } - safe_right, 0)
  let overflow_bottom = max_int({ y + h } - safe_bottom, 0)

  overflow_left + overflow_top + overflow_right + overflow_bottom
}

fn candidate_xy(
  placement: OverlayPlacement,
  anchor: geometry.Rect,
  overlay_w: Int,
  overlay_h: Int,
  offset: Int,
  anchor_cx: Int,
  anchor_cy: Int,
) -> #(Int, Int) {
  let x_left = geometry.rect_x(anchor)
  let x_right = geometry.rect_right(anchor)
  let y_top = geometry.rect_y(anchor)
  let y_bottom = geometry.rect_bottom(anchor)

  case placement {
    OverlayPlacement(side: Above, align: align) -> #(
      aligned_x(align, x_left, x_right, anchor_cx, overlay_w),
      y_top - offset - overlay_h,
    )

    OverlayPlacement(side: Below, align: align) -> #(
      aligned_x(align, x_left, x_right, anchor_cx, overlay_w),
      y_bottom + offset,
    )

    OverlayPlacement(side: Left, align: align) -> #(
      x_left - offset - overlay_w,
      aligned_y(align, y_top, y_bottom, anchor_cy, overlay_h),
    )

    OverlayPlacement(side: Right, align: align) -> #(
      x_right + offset,
      aligned_y(align, y_top, y_bottom, anchor_cy, overlay_h),
    )
  }
}

fn aligned_x(
  align: OverlayAlign,
  anchor_left: Int,
  anchor_right: Int,
  anchor_cx: Int,
  overlay_w: Int,
) -> Int {
  case align {
    Start -> anchor_left
    Center -> anchor_cx - overlay_w / 2
    End -> anchor_right - overlay_w
  }
}

fn aligned_y(
  align: OverlayAlign,
  anchor_top: Int,
  anchor_bottom: Int,
  anchor_cy: Int,
  overlay_h: Int,
) -> Int {
  case align {
    Start -> anchor_top
    Center -> anchor_cy - overlay_h / 2
    End -> anchor_bottom - overlay_h
  }
}

fn compute_arrow(
  arrow arrow: Option(#(Int, Int)),
  placement placement: OverlayPlacement,
  anchor_cx anchor_cx: Int,
  anchor_cy anchor_cy: Int,
  x x: Int,
  y y: Int,
  overlay_w overlay_w: Int,
  overlay_h overlay_h: Int,
) -> #(Option(Int), Option(Int)) {
  case arrow {
    None -> #(None, None)
    Some(#(_size_px, edge_padding_px)) -> {
      let max_x = max_int(edge_padding_px, overlay_w - edge_padding_px)
      let max_y = max_int(edge_padding_px, overlay_h - edge_padding_px)

      case placement {
        OverlayPlacement(side: Above, ..) | OverlayPlacement(side: Below, ..) -> #(
          Some(clamp_int(anchor_cx - x, min: edge_padding_px, max: max_x)),
          None,
        )

        OverlayPlacement(side: Left, ..) | OverlayPlacement(side: Right, ..) -> #(
          None,
          Some(clamp_int(anchor_cy - y, min: edge_padding_px, max: max_y)),
        )
      }
    }
  }
}

/// Get the placement of a solution.
@internal
pub fn overlay_solution_placement(
  solution solution: OverlaySolution,
) -> OverlayPlacement {
  case solution {
    OverlaySolution(placement:, ..) -> placement
  }
}

/// Get the x coordinate of a solution.
@internal
pub fn overlay_solution_x(solution solution: OverlaySolution) -> Int {
  case solution {
    OverlaySolution(x:, ..) -> x
  }
}

/// Get the y coordinate of a solution.
@internal
pub fn overlay_solution_y(solution solution: OverlaySolution) -> Int {
  case solution {
    OverlaySolution(y:, ..) -> y
  }
}

/// Get the arrow x offset (above/below placements only).
@internal
pub fn overlay_solution_arrow_x(
  solution solution: OverlaySolution,
) -> Option(Int) {
  case solution {
    OverlaySolution(arrow_x:, ..) -> arrow_x
  }
}

/// Get the arrow y offset (left/right placements only).
@internal
pub fn overlay_solution_arrow_y(
  solution solution: OverlaySolution,
) -> Option(Int) {
  case solution {
    OverlaySolution(arrow_y:, ..) -> arrow_y
  }
}
