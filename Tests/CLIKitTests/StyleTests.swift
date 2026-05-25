import Testing
@testable import CLIKit

@Suite("Style width + wrap")
struct StyleTests {
    @Test("visible width of a plain string is its character count")
    func plainWidth() {
        #expect(Style.width(of: "hello") == 5)
        #expect(Style.width(of: "") == 0)
    }

    @Test("ANSI escape sequences do not count toward visible width")
    func ansiWidthIgnored() {
        let colored = "\u{1B}[36mhello\u{1B}[0m"
        #expect(Style.width(of: colored) == 5)
    }

    @Test("width counts only the visible run between two escape sequences")
    func ansiWidthMixed() {
        let mixed = "ab\u{1B}[1mcd\u{1B}[0mef"
        #expect(Style.width(of: mixed) == 6)
    }

    @Test("wrap is a no-op when stdout is not a TTY")
    func wrapNoOpOffTTY() {
        // Test output is redirected, so useColor is false.
        #expect(Style.wrap("x", Style.bold) == "x")
    }
}
