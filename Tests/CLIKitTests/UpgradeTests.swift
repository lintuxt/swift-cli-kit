import Foundation
import Testing
@testable import CLIKit

@Suite("Upgrade tag parsing")
struct UpgradeTests {
    @Test("extracts tag_name from a GitHub latest-release payload")
    func extractsTag() throws {
        let json = #"{"tag_name":"v0.1.3","name":"demo v0.1.3"}"#
        let tag = try Upgrade.parseTag(from: Data(json.utf8))
        #expect(tag == "v0.1.3")
    }

    @Test("throws when tag_name is missing")
    func throwsOnMissingTag() {
        let json = #"{"name":"demo"}"#
        #expect(throws: UpgradeError.self) {
            try Upgrade.parseTag(from: Data(json.utf8))
        }
    }

    @Test("throws when tag_name is empty")
    func throwsOnEmptyTag() {
        let json = #"{"tag_name":""}"#
        #expect(throws: UpgradeError.self) {
            try Upgrade.parseTag(from: Data(json.utf8))
        }
    }

    @Test("throws when the payload is not JSON")
    func throwsOnGarbage() {
        #expect(throws: UpgradeError.self) {
            try Upgrade.parseTag(from: Data("not json".utf8))
        }
    }
}
