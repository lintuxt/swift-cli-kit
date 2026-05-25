import Testing
@testable import CLIKit

@Suite("Banner line builders")
struct BannerTests {
    @Test("the banner line shows name, v-prefixed version, and a dotted tagline")
    func bannerLine() {
        let line = Banner.bannerLine(name: "demo", version: "1.2.3", tagline: "a demo tool")
        // Non-TTY: Tone.wrap is a no-op, so the line is plain text.
        #expect(line == "  demo  v1.2.3  · a demo tool")
    }

    @Test("the sponsor footer line shows the heart, label, and url")
    func footerLine() {
        let line = Banner.footerLine(url: "https://example.com/sponsor")
        #expect(line == "  ♥  Looking for sponsors  https://example.com/sponsor")
    }
}
