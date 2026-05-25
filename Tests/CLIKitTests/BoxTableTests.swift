import Testing
@testable import CLIKit

@Suite("BoxTable rendering")
struct BoxTableTests {
    @Test("a one-cell header table draws header, separator, and body")
    func singleCellHeaderTable() {
        let out = BoxTable.render(headers: ["A"], rows: [["x"]])
        #expect(out == """
        ┌───┐
        │ A │
        ├───┤
        │ x │
        └───┘
        """)
    }

    @Test("columns are widened to the widest cell")
    func columnsWidenToContent() {
        let out = BoxTable.render(headers: ["Name"], rows: [["Bob"], ["Alexandra"]])
        let lines = out.split(separator: "\n", omittingEmptySubsequences: false)
        // 1 top rule + header + 1 separator + 2 body rows + bottom rule = 6
        #expect(lines.count == 6)
        // "Alexandra" is 9 wide → inner width 9, line is "│ " + 9 + " │" = 13
        #expect(lines.allSatisfy { $0.count == 13 })
    }

    @Test("grid boxes off every row and has no header separator")
    func gridBoxesEveryRow() {
        let out = BoxTable.grid([["1", "2"], ["3", "4"]])
        #expect(out == """
        ┌───┬───┐
        │ 1 │ 2 │
        ├───┼───┤
        │ 3 │ 4 │
        └───┴───┘
        """)
    }

    @Test("an empty input renders an empty string")
    func emptyInput() {
        #expect(BoxTable.render(headers: [], rows: []) == "")
    }
}
