import startest.{describe, it}
import startest/expect
import sketch
import weft

pub fn main() {
  startest.run(startest.default_config())
}

pub fn weft_tests() {
  describe("weft", [
    describe("length", [
      it("px returns Px", fn() {
        case weft.px(pixels: 12) {
          weft.Px(12) -> 1 |> expect.to_equal(expected: 1)
          _ -> 0 |> expect.to_equal(expected: 1)
        }
      }),
      it("minimum wraps a base and minimum", fn() {
        case weft.minimum(base: weft.fill(), min: weft.px(pixels: 300)) {
          weft.Minimum(weft.Fill, weft.Px(300)) ->
            1 |> expect.to_equal(expected: 1)

          _ ->
            0 |> expect.to_equal(expected: 1)
        }
      }),
    ]),
    describe("class", [
      it("produces a class name", fn() {
        let class = weft.class([weft.padding(pixels: 1)])

        case sketch.stylesheet(strategy: sketch.Ephemeral) {
          Ok(stylesheet) -> {
            let #(_, class_name) = sketch.class_name(class, stylesheet)
            (class_name != "") |> expect.to_equal(expected: True)
          }

          Error(_) ->
            0 |> expect.to_equal(expected: 1)
        }
      }),
    ]),
  ])
}
