import startest.{describe, it}
import startest/expect

pub fn main() {
  startest.run(startest.default_config())
}

pub fn weft_tests() {
  describe("weft", [
    describe("smoke", [
      it("runs", fn() {
        1 |> expect.to_equal(expected: 1)
      }),
    ]),
  ])
}
