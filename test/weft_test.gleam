import startest.{describe, it}
import startest/expect
import sketch/css
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
      it("builds a class name", fn() {
        [weft.padding(pixels: 1)]
        |> weft.class
        |> css.class_name
        |> expect.to_not_equal(expected: "")
      }),
    ]),
  ])
}
