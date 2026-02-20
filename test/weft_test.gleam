import gleam/list
import gleam/option.{Some}
import gleam/string
import startest.{describe, it}
import startest/expect
import weft

pub fn main() {
  startest.run(startest.default_config())
}

pub fn weft_tests() {
  describe("weft", [
    describe("class", [
      it("is order-independent when declarations don't conflict", fn() {
        let a =
          weft.class(attrs: [
            weft.padding(pixels: 1),
            weft.spacing(pixels: 2),
          ])

        let b =
          weft.class(attrs: [
            weft.spacing(pixels: 2),
            weft.padding(pixels: 1),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
      it("last write wins for conflicting declarations", fn() {
        let a =
          weft.class(attrs: [
            weft.padding(pixels: 1),
            weft.padding(pixels: 2),
          ])

        let b = weft.class(attrs: [weft.padding(pixels: 2)])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))

        weft.stylesheet(classes: [a])
        |> expect.to_equal(expected: weft.stylesheet(classes: [b]))
      }),
    ]),
    describe("class_name", [
      it("returns a wf-<8hex> name", fn() {
        let class = weft.class(attrs: [weft.padding(pixels: 1)])
        let name = weft.class_name(class: class)

        string.starts_with(name, "wf-")
        |> expect.to_equal(expected: True)

        string.length(name)
        |> expect.to_equal(expected: 11)
      }),
    ]),
    describe("stylesheet", [
      it("is stable regardless of input order (sorted by class name)", fn() {
        let a = weft.class(attrs: [weft.padding(pixels: 1)])
        let b = weft.class(attrs: [weft.padding(pixels: 2)])

        let css1 = weft.stylesheet(classes: [a, b])
        let css2 = weft.stylesheet(classes: [b, a])

        css1 |> expect.to_equal(expected: css2)
      }),
      it("deduplicates by class name", fn() {
        let a = weft.class(attrs: [weft.padding(pixels: 1)])
        let css = weft.stylesheet(classes: [a, a])

        // One rule means the selector appears exactly once.
        string.split(css, "." <> weft.class_name(class: a))
        |> list.length
        |> expect.to_equal(expected: 2)
      }),
    ]),
    describe("padding_xy", [
      it("uses CSS padding shorthand (y then x)", fn() {
        let class = weft.class(attrs: [weft.padding_xy(x: 3, y: 2)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "padding:2px 3px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("width", [
      it("fill maps to flex-grow and flex-basis", fn() {
        let class = weft.class(attrs: [weft.width(length: weft.fill())])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "flex-grow:1;")
        |> expect.to_equal(expected: True)

        string.contains(css, "flex-basis:0;")
        |> expect.to_equal(expected: True)
      }),
      it("minimum adds min-width", fn() {
        let len = weft.minimum(base: weft.fill(), min: weft.px(pixels: 300))
        let class = weft.class(attrs: [weft.width(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "min-width:300px;")
        |> expect.to_equal(expected: True)
      }),
      it("shrink maps to flex-basis auto and flex-grow 0", fn() {
        let class = weft.class(attrs: [weft.width(length: weft.shrink())])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "flex-grow:0;")
        |> expect.to_equal(expected: True)

        string.contains(css, "flex-basis:auto;")
        |> expect.to_equal(expected: True)
      }),
      it("fill_portion maps to flex-grow portion", fn() {
        let class =
          weft.class(attrs: [weft.width(length: weft.fill_portion(portion: 3))])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "flex-grow:3;")
        |> expect.to_equal(expected: True)
      }),
      it("fixed rem formats without trailing zeros", fn() {
        let len = weft.fixed(length: weft.rem(rem: 1.0))
        let class = weft.class(attrs: [weft.width(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "width:1rem;")
        |> expect.to_equal(expected: True)
      }),
      it("fixed pct formats as a percentage", fn() {
        let len = weft.fixed(length: weft.pct(pct: 50.0))
        let class = weft.class(attrs: [weft.width(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "width:50%;")
        |> expect.to_equal(expected: True)
      }),
      it("maximum adds max-width", fn() {
        let len = weft.maximum(base: weft.fill(), max: weft.px(pixels: 500))
        let class = weft.class(attrs: [weft.width(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "max-width:500px;")
        |> expect.to_equal(expected: True)
      }),
      it("supports nested minimum/maximum constraints", fn() {
        let len =
          weft.minimum(
            base: weft.maximum(base: weft.fill(), max: weft.px(pixels: 500)),
            min: weft.px(pixels: 100),
          )

        let class = weft.class(attrs: [weft.width(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "min-width:100px;")
        |> expect.to_equal(expected: True)

        string.contains(css, "max-width:500px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("height", [
      it("fixed px sets height and disables flex shrink/grow", fn() {
        let len = weft.fixed(length: weft.px(pixels: 10))
        let class = weft.class(attrs: [weft.height(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "height:10px;")
        |> expect.to_equal(expected: True)

        string.contains(css, "flex-grow:0;")
        |> expect.to_equal(expected: True)

        string.contains(css, "flex-shrink:0;")
        |> expect.to_equal(expected: True)
      }),
      it("maximum adds max-height", fn() {
        let len = weft.maximum(base: weft.fill(), max: weft.px(pixels: 123))
        let class = weft.class(attrs: [weft.height(length: len)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "max-height:123px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("colors", [
      it("background(rgb) maps to background-color", fn() {
        let class =
          weft.class(attrs: [
            weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "background-color:rgb(1, 2, 3);")
        |> expect.to_equal(expected: True)
      }),
      it("background(rgba) formats alpha deterministically", fn() {
        let class =
          weft.class(attrs: [
            weft.background(color: weft.rgba(
              red: 1,
              green: 2,
              blue: 3,
              alpha: 0.5,
            )),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "background-color:rgba(1, 2, 3, 0.5);")
        |> expect.to_equal(expected: True)
      }),
      it("accent_color maps to accent-color", fn() {
        let class =
          weft.class(attrs: [
            weft.accent_color(color: weft.rgb(red: 1, green: 2, blue: 3)),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "accent-color:rgb(1, 2, 3);")
        |> expect.to_equal(expected: True)
      }),
      it("rgba rounds alpha to 4 decimal places", fn() {
        let class =
          weft.class(attrs: [
            weft.background(color: weft.rgba(
              red: 1,
              green: 2,
              blue: 3,
              alpha: 0.33335,
            )),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "background-color:rgba(1, 2, 3, 0.3334);")
        |> expect.to_equal(expected: True)
      }),
      it(
        "background_gradient maps to background-image with a linear-gradient()",
        fn() {
          let gradient =
            weft.linear_gradient(stops: [
              weft.gradient_stop(color: weft.rgb(red: 1, green: 2, blue: 3)),
              weft.gradient_stop_at(
                color: weft.rgb(red: 4, green: 5, blue: 6),
                pct: 50.0,
              ),
            ])

          let class =
            weft.class(attrs: [weft.background_gradient(gradient: gradient)])
          let css = weft.stylesheet(classes: [class])

          string.contains(
            css,
            "background-image:linear-gradient(180deg, rgb(1, 2, 3), rgb(4, 5, 6) 50%);",
          )
          |> expect.to_equal(expected: True)
        },
      ),
      it("gradient_stop_at clamps percent to [0, 100]", fn() {
        let gradient =
          weft.linear_gradient(stops: [
            weft.gradient_stop_at(
              color: weft.rgb(red: 1, green: 2, blue: 3),
              pct: -1.0,
            ),
            weft.gradient_stop_at(
              color: weft.rgb(red: 4, green: 5, blue: 6),
              pct: 999.0,
            ),
          ])

        let class =
          weft.class(attrs: [weft.background_gradient(gradient: gradient)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "rgb(1, 2, 3) 0%")
        |> expect.to_equal(expected: True)

        string.contains(css, "rgb(4, 5, 6) 100%")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("alpha", [
      it("sets opacity and formats deterministically", fn() {
        let class = weft.class(attrs: [weft.alpha(opacity: 0.5)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "opacity:0.5;")
        |> expect.to_equal(expected: True)
      }),
      it("clamps opacity to [0, 1]", fn() {
        let over = weft.class(attrs: [weft.alpha(opacity: 2.0)])
        let under = weft.class(attrs: [weft.alpha(opacity: -1.0)])
        let css = weft.stylesheet(classes: [over, under])

        string.contains(css, "opacity:1;")
        |> expect.to_equal(expected: True)

        string.contains(css, "opacity:0;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("visibility", [
      it("display_none removes an element from layout", fn() {
        let class = weft.class(attrs: [weft.display_none()])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "display:none;")
        |> expect.to_equal(expected: True)
      }),
      it("hidden hides an element but keeps its layout space", fn() {
        let class = weft.class(attrs: [weft.hidden()])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "visibility:hidden;")
        |> expect.to_equal(expected: True)
      }),
      it(
        "visually_hidden uses an accessibility-friendly clipping pattern",
        fn() {
          let class = weft.class(attrs: [weft.visually_hidden()])
          let css = weft.stylesheet(classes: [class])

          string.contains(css, "position:absolute;")
          |> expect.to_equal(expected: True)

          string.contains(css, "clip:rect(0 0 0 0);")
          |> expect.to_equal(expected: True)
        },
      ),
    ]),
    describe("positioning", [
      it("sets position:fixed", fn() {
        let class =
          weft.class(attrs: [
            weft.position(value: weft.position_fixed()),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "position:fixed;")
        |> expect.to_equal(expected: True)
      }),
      it("renders inset_xy as top/bottom and left/right", fn() {
        let class =
          weft.class(attrs: [
            weft.inset_xy(x: weft.px(pixels: 1), y: weft.px(pixels: 2)),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "left:1px;")
        |> expect.to_equal(expected: True)

        string.contains(css, "right:1px;")
        |> expect.to_equal(expected: True)

        string.contains(css, "top:2px;")
        |> expect.to_equal(expected: True)

        string.contains(css, "bottom:2px;")
        |> expect.to_equal(expected: True)
      }),
      it("last write wins for conflicting inset properties", fn() {
        let class =
          weft.class(attrs: [
            weft.top(length: weft.px(pixels: 1)),
            weft.top(length: weft.px(pixels: 2)),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "top:2px;")
        |> expect.to_equal(expected: True)

        string.contains(css, "top:1px;")
        |> expect.to_equal(expected: False)
      }),
    ]),
    describe("flex_alignment", [
      it("sets justify-content, align-items, and flex-wrap", fn() {
        let class =
          weft.class(attrs: [
            weft.justify_content(value: weft.justify_space_between()),
            weft.align_items(value: weft.align_items_center()),
            weft.flex_wrap(value: weft.wrap()),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "justify-content:space-between;")
        |> expect.to_equal(expected: True)

        string.contains(css, "align-items:center;")
        |> expect.to_equal(expected: True)

        string.contains(css, "flex-wrap:wrap;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("display", [
      it("sets display:inline-block", fn() {
        let class =
          weft.class(attrs: [weft.display(value: weft.display_inline_block())])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "display:inline-block;")
        |> expect.to_equal(expected: True)
      }),
      it("sets vertical-align via keyword and length", fn() {
        let class =
          weft.class(attrs: [
            weft.vertical_align(value: weft.vertical_align_middle()),
            weft.vertical_align(
              value: weft.vertical_align_length(length: weft.px(pixels: 3)),
            ),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "vertical-align:3px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("transform", [
      it("renders transform items joined by spaces", fn() {
        let class =
          weft.class(attrs: [
            weft.transform(items: [
              weft.translate(x: weft.px(pixels: 1), y: weft.px(pixels: 2)),
              weft.rotate_degrees(deg: 45.0),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "transform:translate(1px, 2px) rotate(45deg);")
        |> expect.to_equal(expected: True)
      }),
      it("renders transform:none for an empty list", fn() {
        let class = weft.class(attrs: [weft.transform(items: [])])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "transform:none;")
        |> expect.to_equal(expected: True)
      }),
      it("clamps scale values to be non-negative", fn() {
        let class =
          weft.class(attrs: [
            weft.transform(items: [weft.scale(x: -1.0, y: 0.5)]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "scale(0, 0.5)")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("hygiene", [
      it("sets text-decoration, user-select, and appearance", fn() {
        let class =
          weft.class(attrs: [
            weft.text_decoration(value: weft.text_decoration_underline()),
            weft.user_select(value: weft.user_select_none()),
            weft.appearance(value: weft.appearance_none()),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "text-decoration:underline;")
        |> expect.to_equal(expected: True)

        string.contains(css, "user-select:none;")
        |> expect.to_equal(expected: True)

        string.contains(css, "appearance:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("cursor", [
      it("sets cursor:pointer", fn() {
        let class =
          weft.class(attrs: [weft.cursor(cursor: weft.cursor_pointer())])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "cursor:pointer;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("pointer_events", [
      it("sets pointer-events:none", fn() {
        let class =
          weft.class(attrs: [
            weft.pointer_events(value: weft.pointer_events_none()),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "pointer-events:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("overflow", [
      it("sets overflow:hidden", fn() {
        let class =
          weft.class(attrs: [weft.overflow(overflow: weft.overflow_hidden())])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "overflow:hidden;")
        |> expect.to_equal(expected: True)
      }),
      it("sets overflow-x and overflow-y", fn() {
        let class =
          weft.class(attrs: [
            weft.overflow_x(overflow: weft.overflow_scroll()),
            weft.overflow_y(overflow: weft.overflow_auto()),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "overflow-x:scroll;")
        |> expect.to_equal(expected: True)

        string.contains(css, "overflow-y:auto;")
        |> expect.to_equal(expected: True)
      }),
      it("provides scroll_x/scroll_y/scroll_both conveniences", fn() {
        let class =
          weft.class(attrs: [
            weft.scroll_x(),
            weft.scroll_y(),
            weft.scroll_both(),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "overflow-x:auto;")
        |> expect.to_equal(expected: True)

        string.contains(css, "overflow-y:auto;")
        |> expect.to_equal(expected: True)

        string.contains(css, "overflow:auto;")
        |> expect.to_equal(expected: True)
      }),
      it("sets overscroll behavior", fn() {
        let class =
          weft.class(attrs: [
            weft.overscroll_behavior(value: weft.overscroll_contain()),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "overscroll-behavior:contain;")
        |> expect.to_equal(expected: True)
      }),
      it("sets scrollbar helpers where supported", fn() {
        let class =
          weft.class(attrs: [
            weft.scrollbar_gutter(gutter: weft.scrollbar_gutter_stable()),
            weft.scrollbar_width(width: weft.scrollbar_width_thin()),
            weft.scrollbar_color(
              thumb: weft.rgb(red: 1, green: 2, blue: 3),
              track: weft.rgb(red: 4, green: 5, blue: 6),
            ),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "scrollbar-gutter:stable;")
        |> expect.to_equal(expected: True)

        string.contains(css, "scrollbar-width:thin;")
        |> expect.to_equal(expected: True)

        string.contains(css, "scrollbar-color:rgb(1, 2, 3) rgb(4, 5, 6);")
        |> expect.to_equal(expected: True)
      }),
      it("sets scroll snap properties", fn() {
        let class =
          weft.class(attrs: [
            weft.scroll_snap_type(value: weft.scroll_snap_type_x_mandatory()),
            weft.scroll_snap_align(value: weft.scroll_snap_align_center()),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "scroll-snap-type:x mandatory;")
        |> expect.to_equal(expected: True)

        string.contains(css, "scroll-snap-align:center;")
        |> expect.to_equal(expected: True)
      }),
      it("sets smooth scroll behavior", fn() {
        let class =
          weft.class(attrs: [
            weft.scroll_behavior(behavior: weft.scroll_behavior_smooth()),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "scroll-behavior:smooth;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("outline", [
      it("renders a solid outline and offset", fn() {
        let class =
          weft.class(attrs: [
            weft.outline(
              width: weft.px(pixels: 2),
              color: weft.rgb(red: 1, green: 2, blue: 3),
            ),
            weft.outline_offset(length: weft.px(pixels: 3)),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "outline:2px solid rgb(1, 2, 3);")
        |> expect.to_equal(expected: True)

        string.contains(css, "outline-offset:3px;")
        |> expect.to_equal(expected: True)
      }),
      it("can remove the outline", fn() {
        let class = weft.class(attrs: [weft.outline_none()])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "outline:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("media", [
      it("sets aspect-ratio and clamps width/height to be at least 1", fn() {
        let class = weft.class(attrs: [weft.aspect_ratio(width: 0, height: -1)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "aspect-ratio:1 / 1;")
        |> expect.to_equal(expected: True)
      }),
      it("sets object-fit", fn() {
        let class =
          weft.class(attrs: [weft.object_fit(fit: weft.object_fit_cover())])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "object-fit:cover;")
        |> expect.to_equal(expected: True)
      }),
      it("image_layout provides sensible defaults", fn() {
        let class = weft.class(attrs: [weft.image_layout()])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "display:block;")
        |> expect.to_equal(expected: True)

        string.contains(css, "max-width:100%;")
        |> expect.to_equal(expected: True)

        string.contains(css, "height:auto;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("grid", [
      it("grid_layout maps to display:grid", fn() {
        let class = weft.class(attrs: [weft.grid_layout()])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "display:grid;")
        |> expect.to_equal(expected: True)
      }),
      it("grid_columns renders a space-separated track list", fn() {
        let class =
          weft.class(attrs: [
            weft.grid_columns(tracks: [
              weft.grid_fr(fr: 1.0),
              weft.grid_fixed(length: weft.px(pixels: 100)),
              weft.grid_auto(),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "grid-template-columns:1fr 100px auto;")
        |> expect.to_equal(expected: True)
      }),
      it("grid_repeat and grid_minmax render nested track expressions", fn() {
        let track =
          weft.grid_repeat(
            count: 3,
            track: weft.grid_minmax(
              min: weft.grid_fixed(length: weft.px(pixels: 100)),
              max: weft.grid_fr(fr: 1.0),
            ),
          )

        let class = weft.class(attrs: [weft.grid_columns(tracks: [track])])
        let css = weft.stylesheet(classes: [class])

        string.contains(
          css,
          "grid-template-columns:repeat(3, minmax(100px, 1fr));",
        )
        |> expect.to_equal(expected: True)
      }),
      it("grid_column and grid_row clamp to be at least 1", fn() {
        let class =
          weft.class(attrs: [
            weft.grid_column(start: 0, span: -1),
            weft.grid_row(start: 0, span: -1),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "grid-column:1 / span 1;")
        |> expect.to_equal(expected: True)

        string.contains(css, "grid-row:1 / span 1;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("mouse_over", [
      it("renders :hover nested rules", fn() {
        let class =
          weft.class(attrs: [
            weft.mouse_over(attrs: [
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
            ]),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, ":hover{background-color:rgb(1, 2, 3);}")
        |> expect.to_equal(expected: True)
      }),
      it("is order-independent within the nested rules", fn() {
        let a =
          weft.class(attrs: [
            weft.mouse_over(attrs: [
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
              weft.text_color(color: weft.rgb(red: 4, green: 5, blue: 6)),
            ]),
          ])

        let b =
          weft.class(attrs: [
            weft.mouse_over(attrs: [
              weft.text_color(color: weft.rgb(red: 4, green: 5, blue: 6)),
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
            ]),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
      it("last write wins across multiple mouse_over attributes", fn() {
        let a =
          weft.class(attrs: [
            weft.mouse_over(attrs: [weft.padding(pixels: 1)]),
            weft.mouse_over(attrs: [weft.padding(pixels: 2)]),
          ])

        let b =
          weft.class(attrs: [
            weft.mouse_over(attrs: [weft.padding(pixels: 2)]),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))

        weft.stylesheet(classes: [a])
        |> expect.to_equal(expected: weft.stylesheet(classes: [b]))
      }),
    ]),
    describe("focus_visible", [
      it("renders :focus-visible nested rules", fn() {
        let class =
          weft.class(attrs: [
            weft.focus_visible(attrs: [
              weft.outline(
                width: weft.px(pixels: 2),
                color: weft.rgb(red: 1, green: 2, blue: 3),
              ),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, ":focus-visible{outline:2px solid rgb(1, 2, 3);}")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("when", [
      it("renders @media blocks", fn() {
        let query = weft.min_width(length: weft.px(pixels: 600))
        let class =
          weft.class(attrs: [
            weft.when(query: query, attrs: [
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "@media (min-width:600px){\n")
        |> expect.to_equal(expected: True)

        string.contains(css, "background-color:rgb(1, 2, 3);")
        |> expect.to_equal(expected: True)
      }),
      it("is order-independent across distinct media queries", fn() {
        let a =
          weft.class(attrs: [
            weft.when(
              query: weft.min_width(length: weft.px(pixels: 600)),
              attrs: [
                weft.padding(pixels: 1),
              ],
            ),
            weft.when(
              query: weft.max_width(length: weft.px(pixels: 800)),
              attrs: [
                weft.padding(pixels: 2),
              ],
            ),
          ])

        let b =
          weft.class(attrs: [
            weft.when(
              query: weft.max_width(length: weft.px(pixels: 800)),
              attrs: [
                weft.padding(pixels: 2),
              ],
            ),
            weft.when(
              query: weft.min_width(length: weft.px(pixels: 600)),
              attrs: [
                weft.padding(pixels: 1),
              ],
            ),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
      it("last write wins across multiple when() for the same query", fn() {
        let query = weft.min_width(length: weft.px(pixels: 600))

        let a =
          weft.class(attrs: [
            weft.when(query: query, attrs: [weft.padding(pixels: 1)]),
            weft.when(query: query, attrs: [weft.padding(pixels: 2)]),
          ])

        let b =
          weft.class(attrs: [
            weft.when(query: query, attrs: [weft.padding(pixels: 2)]),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))

        weft.stylesheet(classes: [a])
        |> expect.to_equal(expected: weft.stylesheet(classes: [b]))
      }),
    ]),
    describe("when_container", [
      it("renders @container blocks", fn() {
        let query = weft.container_min_width(length: weft.px(pixels: 640))
        let class =
          weft.class(attrs: [
            weft.when_container(query: query, attrs: [
              weft.padding(pixels: 12),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "@container (min-width:640px){\n")
        |> expect.to_equal(expected: True)

        string.contains(css, "padding:12px;")
        |> expect.to_equal(expected: True)
      }),
      it("supports container-inline-size and container-name declarations", fn() {
        let class =
          weft.class(attrs: [
            weft.container_inline_size(),
            weft.container_name(value: "dashboard"),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "container-type:inline-size;")
        |> expect.to_equal(expected: True)

        string.contains(css, "container-name:dashboard;")
        |> expect.to_equal(expected: True)
      }),
      it("is order-independent across distinct container queries", fn() {
        let a =
          weft.class(attrs: [
            weft.when_container(
              query: weft.container_min_width(length: weft.px(pixels: 640)),
              attrs: [
                weft.padding(pixels: 1),
              ],
            ),
            weft.when_container(
              query: weft.container_max_width(length: weft.px(pixels: 900)),
              attrs: [
                weft.padding(pixels: 2),
              ],
            ),
          ])

        let b =
          weft.class(attrs: [
            weft.when_container(
              query: weft.container_max_width(length: weft.px(pixels: 900)),
              attrs: [
                weft.padding(pixels: 2),
              ],
            ),
            weft.when_container(
              query: weft.container_min_width(length: weft.px(pixels: 640)),
              attrs: [
                weft.padding(pixels: 1),
              ],
            ),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
    ]),
    describe("transitions", [
      it("renders a single transition via transition()", fn() {
        let class =
          weft.class(attrs: [
            weft.transition(
              property: weft.transition_property_opacity(),
              duration: weft.ms(milliseconds: 150),
              easing: weft.ease_in_out(),
            ),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "transition:opacity 150ms ease-in-out;")
        |> expect.to_equal(expected: True)
      }),
      it("canonicalizes transitions to be order-independent", fn() {
        let t1 =
          weft.transition_item(
            property: weft.transition_property_opacity(),
            duration: weft.ms(milliseconds: 150),
            easing: weft.ease(),
          )

        let t2 =
          weft.transition_item(
            property: weft.transition_property_background_color(),
            duration: weft.ms(milliseconds: 200),
            easing: weft.linear(),
          )

        let a = weft.class(attrs: [weft.transitions(transitions: [t1, t2])])
        let b = weft.class(attrs: [weft.transitions(transitions: [t2, t1])])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
      it("last write wins for duplicate transition properties", fn() {
        let t1 =
          weft.transition_item(
            property: weft.transition_property_opacity(),
            duration: weft.ms(milliseconds: 100),
            easing: weft.ease(),
          )

        let t2 =
          weft.transition_item(
            property: weft.transition_property_opacity(),
            duration: weft.ms(milliseconds: 200),
            easing: weft.ease(),
          )

        let a = weft.class(attrs: [weft.transitions(transitions: [t1, t2])])
        let b = weft.class(attrs: [weft.transitions(transitions: [t2])])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))

        weft.stylesheet(classes: [a])
        |> expect.to_equal(expected: weft.stylesheet(classes: [b]))
      }),
      it("renders transition:none for an empty list", fn() {
        let class = weft.class(attrs: [weft.transitions(transitions: [])])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "transition:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("typography", [
      it("sets font-family with safe quoting and fallbacks", fn() {
        let class =
          weft.class(attrs: [
            weft.font_family(families: [
              weft.font(name: "Inter"),
              weft.font_sans_serif(),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "font-family:\"Inter\", sans-serif;")
        |> expect.to_equal(expected: True)
      }),
      it(
        "sets font-size, font-weight, line-height, letter-spacing, and text-align",
        fn() {
          let class =
            weft.class(attrs: [
              weft.font_size(size: weft.px(pixels: 16)),
              weft.font_weight(weight: weft.font_weight_value(weight: 500)),
              weft.line_height(height: weft.line_height_multiple(
                multiplier: 1.5,
              )),
              weft.letter_spacing(length: weft.px(pixels: 1)),
              weft.text_align(align: weft.text_align_center()),
            ])

          let css = weft.stylesheet(classes: [class])

          string.contains(css, "font-size:16px;")
          |> expect.to_equal(expected: True)

          string.contains(css, "font-weight:500;")
          |> expect.to_equal(expected: True)

          string.contains(css, "line-height:1.5;")
          |> expect.to_equal(expected: True)

          string.contains(css, "letter-spacing:1px;")
          |> expect.to_equal(expected: True)

          string.contains(css, "text-align:center;")
          |> expect.to_equal(expected: True)
        },
      ),
    ]),
    describe("border", [
      it("renders border and border-radius", fn() {
        let class =
          weft.class(attrs: [
            weft.border(
              width: weft.px(pixels: 1),
              style: weft.border_style_solid(),
              color: weft.rgb(red: 1, green: 2, blue: 3),
            ),
            weft.rounded(radius: weft.px(pixels: 4)),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(css, "border:1px solid rgb(1, 2, 3);")
        |> expect.to_equal(expected: True)

        string.contains(css, "border-radius:4px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("shadows", [
      it("renders box-shadow entries including inset", fn() {
        let outer =
          weft.shadow(
            x: weft.px(pixels: 0),
            y: weft.px(pixels: 1),
            blur: weft.px(pixels: 2),
            spread: weft.px(pixels: 0),
            color: weft.rgba(red: 0, green: 0, blue: 0, alpha: 0.2),
          )

        let inner =
          weft.inner_shadow(
            x: weft.px(pixels: 0),
            y: weft.px(pixels: 0),
            blur: weft.px(pixels: 1),
            spread: weft.px(pixels: 0),
            color: weft.rgb(red: 1, green: 2, blue: 3),
          )

        let class =
          weft.class(attrs: [
            weft.shadows(shadows: [outer, inner]),
          ])

        let css = weft.stylesheet(classes: [class])

        string.contains(
          css,
          "box-shadow:0px 1px 2px 0px rgba(0, 0, 0, 0.2), inset 0px 0px 1px 0px rgb(1, 2, 3);",
        )
        |> expect.to_equal(expected: True)
      }),
      it("renders box-shadow:none for an empty list", fn() {
        let class = weft.class(attrs: [weft.shadows(shadows: [])])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "box-shadow:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("overlay_micro_solver", [
      it("flips when the preferred side clips more", fn() {
        let anchor = weft.rect(x: 10, y: 90, width: 10, height: 10)
        let overlay = weft.size(width: 30, height: 30)
        let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

        let problem =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_prefer_sides(sides: [
            weft.overlay_side_below(),
            weft.overlay_side_above(),
          ])

        let solution = weft.solve_overlay(problem: problem)

        weft.overlay_solution_placement(solution: solution)
        |> weft.overlay_placement_side
        |> expect.to_equal(expected: weft.overlay_side_above())
      }),
      it(
        "restores default side order when an empty prefer list is passed",
        fn() {
          let anchor = weft.rect(x: 10, y: 90, width: 10, height: 10)
          let overlay = weft.size(width: 30, height: 30)
          let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

          let with_empty =
            weft.overlay_problem(
              anchor: anchor,
              overlay: overlay,
              viewport: viewport,
            )
            |> weft.overlay_prefer_sides(sides: [])

          let with_left_only =
            weft.overlay_problem(
              anchor: anchor,
              overlay: overlay,
              viewport: viewport,
            )
            |> weft.overlay_prefer_sides(sides: [weft.overlay_side_left()])

          weft.solve_overlay(problem: with_empty)
          |> weft.overlay_solution_placement
          |> weft.overlay_placement_side
          |> expect.to_equal(expected: weft.overlay_side_above())

          weft.solve_overlay(problem: with_left_only)
          |> weft.overlay_solution_placement
          |> weft.overlay_placement_side
          |> expect.to_equal(expected: weft.overlay_side_left())
        },
      ),
      it("restores default alignments when an empty align list is passed", fn() {
        let anchor = weft.rect(x: 30, y: 10, width: 20, height: 10)
        let overlay = weft.size(width: 30, height: 20)
        let viewport = weft.rect(x: 0, y: 0, width: 200, height: 200)

        let with_default =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_prefer_sides(sides: [weft.overlay_side_below()])
          |> weft.overlay_alignments(aligns: [])

        let with_start =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_prefer_sides(sides: [weft.overlay_side_below()])
          |> weft.overlay_alignments(aligns: [weft.overlay_align_start()])

        let solution_default = weft.solve_overlay(problem: with_default)
        let solution_start = weft.solve_overlay(problem: with_start)

        weft.overlay_solution_x(solution: solution_default)
        |> expect.to_equal(expected: 25)

        weft.overlay_solution_x(solution: solution_start)
        |> expect.to_equal(expected: 30)
      }),
      it("normalizes negative offset/padding to zero", fn() {
        let anchor = weft.rect(x: 10, y: 10, width: 10, height: 10)
        let overlay = weft.size(width: 20, height: 20)
        let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

        let zero =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_offset(pixels: 0)
          |> weft.overlay_padding(pixels: 0)

        let adjusted =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_offset(pixels: -12)
          |> weft.overlay_padding(pixels: -20)

        let a = weft.solve_overlay(problem: zero)
        let b = weft.solve_overlay(problem: adjusted)

        weft.overlay_solution_x(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_x(solution: b))

        weft.overlay_solution_y(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_y(solution: b))
      }),
      it("shifts along the cross-axis to stay within viewport padding", fn() {
        let anchor = weft.rect(x: 95, y: 10, width: 5, height: 5)
        let overlay = weft.size(width: 30, height: 20)
        let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

        let problem =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_prefer_sides(sides: [weft.overlay_side_below()])
          |> weft.overlay_alignments(aligns: [weft.overlay_align_start()])
          |> weft.overlay_padding(pixels: 4)

        let solution = weft.solve_overlay(problem: problem)

        // Unshifted would be x=95; with padding=4 and overlay_w=30,
        // clamp to safe_right(96) - 30 = 66.
        weft.overlay_solution_x(solution: solution)
        |> expect.to_equal(expected: 66)
      }),
      it("is deterministic for identical inputs", fn() {
        let anchor = weft.rect(x: 20, y: 20, width: 10, height: 10)
        let overlay = weft.size(width: 40, height: 20)
        let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

        let problem =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_offset(pixels: 8)
          |> weft.overlay_padding(pixels: 4)
          |> weft.overlay_arrow(size_px: 10, edge_padding_px: 6)

        let a = weft.solve_overlay(problem: problem)
        let b = weft.solve_overlay(problem: problem)

        weft.overlay_solution_placement(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_placement(
          solution: b,
        ))

        weft.overlay_solution_x(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_x(solution: b))

        weft.overlay_solution_y(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_y(solution: b))

        weft.overlay_solution_arrow_x(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_arrow_x(solution: b))

        weft.overlay_solution_arrow_y(solution: a)
        |> expect.to_equal(expected: weft.overlay_solution_arrow_y(solution: b))
      }),
      it("clamps arrow offsets away from overlay edges", fn() {
        let anchor = weft.rect(x: 0, y: 0, width: 1, height: 1)
        let overlay = weft.size(width: 20, height: 10)
        let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

        let problem =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_prefer_sides(sides: [weft.overlay_side_below()])
          |> weft.overlay_alignments(aligns: [weft.overlay_align_start()])
          |> weft.overlay_arrow(size_px: 6, edge_padding_px: 8)

        let solution = weft.solve_overlay(problem: problem)

        // Anchor center is at x=0 (width=1 => floor(0.5)=0),
        // so raw arrow_x would be <= 0, but it clamps to edge_padding (8).
        weft.overlay_solution_arrow_x(solution: solution)
        |> expect.to_equal(expected: Some(8))
      }),
      it("produces a stable clamped solution for an oversized overlay", fn() {
        let anchor = weft.rect(x: 10, y: 10, width: 10, height: 10)
        let overlay = weft.size(width: 200, height: 200)
        let viewport = weft.rect(x: 0, y: 0, width: 100, height: 100)

        let problem =
          weft.overlay_problem(
            anchor: anchor,
            overlay: overlay,
            viewport: viewport,
          )
          |> weft.overlay_padding(pixels: 4)

        let solution = weft.solve_overlay(problem: problem)

        // When the overlay is larger than the safe viewport, we clamp to the
        // safe top-left.
        weft.overlay_solution_x(solution: solution)
        |> expect.to_equal(expected: 4)

        weft.overlay_solution_y(solution: solution)
        |> expect.to_equal(expected: 4)
      }),
    ]),
    describe("margin", [
      it("sets uniform margin on all sides", fn() {
        let class = weft.class(attrs: [weft.margin(pixels: 8)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "margin:8px;")
        |> expect.to_equal(expected: True)
      }),
      it("sets zero margin", fn() {
        let class = weft.class(attrs: [weft.margin(pixels: 0)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "margin:0px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("margin_xy", [
      it("uses CSS margin shorthand (y then x)", fn() {
        let class = weft.class(attrs: [weft.margin_xy(x: 4, y: 8)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "margin:8px 4px;")
        |> expect.to_equal(expected: True)
      }),
      it("is order-independent with other attributes", fn() {
        let a =
          weft.class(attrs: [
            weft.margin_xy(x: 4, y: 8),
            weft.padding(pixels: 2),
          ])

        let b =
          weft.class(attrs: [
            weft.padding(pixels: 2),
            weft.margin_xy(x: 4, y: 8),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
    ]),
    describe("margin_top", [
      it("sets margin-top only", fn() {
        let class = weft.class(attrs: [weft.margin_top(pixels: 12)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "margin-top:12px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("margin_bottom", [
      it("sets margin-bottom only", fn() {
        let class = weft.class(attrs: [weft.margin_bottom(pixels: 16)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "margin-bottom:16px;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("fit_content", [
      it("generates fit-content as a CssLength value", fn() {
        let class =
          weft.class(attrs: [
            weft.width(length: weft.fixed(length: weft.fit_content())),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "width:fit-content;")
        |> expect.to_equal(expected: True)
      }),
      it("can be used in a min-width constraint", fn() {
        let class =
          weft.class(attrs: [
            weft.width(length: weft.minimum(
              base: weft.shrink(),
              min: weft.fit_content(),
            )),
          ])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "min-width:fit-content;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("group", [
      it("attaches the weft-group-<name> class as an extra class", fn() {
        let class = weft.class(attrs: [weft.group(name: "card")])

        weft.class_extra_names(class: class)
        |> expect.to_equal(expected: ["weft-group-card"])
      }),
      it("deduplicates extra class names when group is applied twice", fn() {
        let class =
          weft.class(attrs: [weft.group(name: "row"), weft.group(name: "row")])

        weft.class_extra_names(class: class)
        |> expect.to_equal(expected: ["weft-group-row"])
      }),
      it("accumulates multiple distinct group names", fn() {
        let class =
          weft.class(attrs: [
            weft.group(name: "alpha"),
            weft.group(name: "beta"),
          ])

        weft.class_extra_names(class: class)
        |> expect.to_equal(expected: ["weft-group-alpha", "weft-group-beta"])
      }),
    ]),
    describe("group_hover", [
      it("generates an ancestor-scoped :hover rule", fn() {
        let class =
          weft.class(attrs: [
            weft.group_hover(group: "card", attrs: [
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
            ]),
          ])

        let css = weft.stylesheet(classes: [class])
        let class_name = weft.class_name(class: class)

        string.contains(
          css,
          ".weft-group-card:hover ."
            <> class_name
            <> "{background-color:rgb(1, 2, 3);}",
        )
        |> expect.to_equal(expected: True)
      }),
      it("is order-independent within the nested rules", fn() {
        let a =
          weft.class(attrs: [
            weft.group_hover(group: "card", attrs: [
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
              weft.text_color(color: weft.rgb(red: 4, green: 5, blue: 6)),
            ]),
          ])

        let b =
          weft.class(attrs: [
            weft.group_hover(group: "card", attrs: [
              weft.text_color(color: weft.rgb(red: 4, green: 5, blue: 6)),
              weft.background(color: weft.rgb(red: 1, green: 2, blue: 3)),
            ]),
          ])

        weft.class_name(class: a)
        |> expect.to_equal(expected: weft.class_name(class: b))
      }),
    ]),
    describe("hide_below", [
      it("MobileBreakpoint hides below 768px", fn() {
        let class =
          weft.class(attrs: [weft.hide_below(breakpoint: weft.MobileBreakpoint)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "@media (max-width:767px)")
        |> expect.to_equal(expected: True)

        string.contains(css, "display:none;")
        |> expect.to_equal(expected: True)
      }),
      it("TabletBreakpoint hides below 1024px", fn() {
        let class =
          weft.class(attrs: [weft.hide_below(breakpoint: weft.TabletBreakpoint)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "@media (max-width:1023px)")
        |> expect.to_equal(expected: True)

        string.contains(css, "display:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("show_below", [
      it("MobileBreakpoint hides above 768px", fn() {
        let class =
          weft.class(attrs: [weft.show_below(breakpoint: weft.MobileBreakpoint)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "@media (min-width:768px)")
        |> expect.to_equal(expected: True)

        string.contains(css, "display:none;")
        |> expect.to_equal(expected: True)
      }),
      it("TabletBreakpoint hides above 1024px", fn() {
        let class =
          weft.class(attrs: [weft.show_below(breakpoint: weft.TabletBreakpoint)])
        let css = weft.stylesheet(classes: [class])

        string.contains(css, "@media (min-width:1024px)")
        |> expect.to_equal(expected: True)

        string.contains(css, "display:none;")
        |> expect.to_equal(expected: True)
      }),
    ]),
    describe("class_extra_names", [
      it("returns an empty list when no extra classes are attached", fn() {
        let class = weft.class(attrs: [weft.padding(pixels: 8)])

        weft.class_extra_names(class: class)
        |> expect.to_equal(expected: [])
      }),
    ]),
  ])
}
