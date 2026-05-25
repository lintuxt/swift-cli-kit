import Testing
@testable import CLIKit

@Suite("SemVer comparison")
struct SemVerTests {
    @Test("a newer patch is newer")
    func newerPatch() {
        #expect(SemVer.isNewer("v0.1.3", than: "v0.1.2"))
    }

    @Test("a newer minor is newer")
    func newerMinor() {
        #expect(SemVer.isNewer("v0.2.0", than: "v0.1.9"))
    }

    @Test("a newer major is newer")
    func newerMajor() {
        #expect(SemVer.isNewer("v2.0.0", than: "v1.9.9"))
    }

    @Test("equal versions are not newer")
    func equalNotNewer() {
        #expect(!SemVer.isNewer("v1.2.3", than: "v1.2.3"))
    }

    @Test("an older version is not newer")
    func olderNotNewer() {
        #expect(!SemVer.isNewer("v1.0.0", than: "v1.0.1"))
    }

    @Test("missing components count as zero")
    func missingComponentsAreZero() {
        #expect(SemVer.isNewer("v1.1", than: "v1"))
        #expect(!SemVer.isNewer("v1.0", than: "v1.0.0"))
    }

    @Test("a leading v is optional on either side")
    func leadingVOptional() {
        #expect(SemVer.isNewer("1.2.3", than: "v1.2.2"))
        #expect(SemVer.isNewer("v1.2.3", than: "1.2.2"))
    }
}
