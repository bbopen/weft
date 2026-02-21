# weft

[![Package Version](https://img.shields.io/hexpm/v/weft)](https://hex.pm/packages/weft)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/weft/)

Layout primitives for Gleam, inspired by Elm-UI. You describe layout with
typed constructors instead of writing CSS by hand. Weft compiles those
constructors into deterministic class names and a deduped stylesheet.

It has no framework dependency. The core package produces plain class names
and CSS strings that any renderer (Lustre, Nakai, raw HTML templates) can use.

## Installation

Weft isn't on Hex yet. Add it as a git dependency:

```toml
[dependencies]
weft = { git = "https://github.com/bbopen/weft", branch = "main" }
```

## Quick example

```gleam
import weft

pub fn card() {
  // Build a class from typed attributes
  let card_class =
    weft.class(attrs: [
      weft.column_layout(),
      weft.padding(pixels: 16),
      weft.spacing(pixels: 8),
      weft.width(length: weft.fill()),
      weft.background(color: weft.rgb(red: 255, green: 255, blue: 255)),
      weft.rounded(radius: weft.px(pixels: 8)),
      weft.mouse_over(attrs: [
        weft.background(color: weft.rgb(red: 245, green: 245, blue: 245)),
      ]),
    ])

  // Get the class name to put on your element
  let name = weft.class_name(class: card_class)
  // => "wf-a3b2c1d4"

  // Render the stylesheet for all your classes
  let css = weft.stylesheet(classes: [card_class])
  // => ".wf-a3b2c1d4{display:flex;flex-direction:column;...}"
}
```

No CSS strings anywhere. Every value is typed and checked at compile time.

## How deterministic CSS works

Weft hashes the compiled CSS declarations with FNV-1a to produce class names
like `wf-a3b2c1d4`. The same set of attributes always produces the same hash.
Two elements that share identical styling get the same class name automatically,
so the stylesheet never contains duplicates.

This means you can call `weft.class()` freely in render functions without
worrying about CSS bloat. If the attributes match, the output is reused.

## What's in the box

The API covers the layout and styling primitives you'd reach for in a
typical web UI:

- Flex layouts: `row_layout`, `column_layout`, `spacing`, `padding`
- Grid layouts: `grid_layout`, `grid_columns`, `grid_rows`, `grid_fr`
- Sizing: `fill`, `shrink`, `fill_portion`, `fixed`, `minimum`, `maximum`
- Colors: `rgb`, `rgba`, `hsl`, `hex`, `transparent`, `current_color`
- Typography: `font_size`, `font_weight`, `font_family`, `line_height`, `text_align`
- Borders and rounding: `border`, `rounded`, `shadows`, `outline`
- Positioning: `position`, `top`, `left`, `right`, `bottom`, `inset`
- Transitions: `transition`, `transitions` with typed duration and easing
- Pseudo-states: `mouse_over`, `focused`, `active`, `disabled`, `focus_visible`
- Responsive: `when` (media queries), `when_container`, `hide_below`, `show_below`
- Scroll: `scroll_x`, `scroll_y`, `overflow`, `scroll_snap_type`
- Overlay positioning: a constraint solver for anchored overlays (dropdowns, tooltips)
- Filters: `filter_blur`, `filter_brightness`, `backdrop_filter`
- Groups: `group` / `group_hover` for parent-scoped hover effects

All values go through opaque types. There's no `style("property", "value")`
escape hatch in the public API.

## Cross-target

Weft is pure Gleam with no FFI. It builds on both Erlang and JavaScript
targets. The only dependency is `gleam_stdlib`.

## License

Apache 2.0 -- see [LICENSE](LICENSE).
