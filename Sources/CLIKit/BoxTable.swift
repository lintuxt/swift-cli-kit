/// Renders grids of strings as Unicode box-drawing tables. Cell content may
/// contain ANSI color codes — column widths are measured by visible width.
public enum BoxTable {
    /// A table with a header row separated from the body.
    public static func render(headers: [String], rows: [[String]]) -> String {
        draw([headers] + rows, headerRow: true, gridLines: false)
    }

    /// A grid with every row boxed off and no header — e.g. a layout map.
    public static func grid(_ rows: [[String]]) -> String {
        draw(rows, headerRow: false, gridLines: true)
    }

    private static func draw(_ rows: [[String]], headerRow: Bool, gridLines: Bool) -> String {
        guard !rows.isEmpty, rows.contains(where: { !$0.isEmpty }) else { return "" }
        let columns = rows.map(\.count).max() ?? 0

        var widths = [Int](repeating: 0, count: columns)
        for row in rows {
            for index in 0..<columns {
                let cell = index < row.count ? row[index] : ""
                widths[index] = max(widths[index], Style.width(of: cell))
            }
        }

        let bar = Style.wrap("│", Style.dim)
        func rule(_ left: String, _ joint: String, _ right: String) -> String {
            let line = left + widths
                .map { String(repeating: "─", count: $0 + 2) }
                .joined(separator: joint) + right
            return Style.wrap(line, Style.dim)
        }
        func line(_ cells: [String]) -> String {
            var rendered = bar
            for index in 0..<columns {
                let cell = index < cells.count ? cells[index] : ""
                let padding = String(repeating: " ", count: widths[index] - Style.width(of: cell))
                rendered += " " + cell + padding + " " + bar
            }
            return rendered
        }

        var lines = [rule("┌", "┬", "┐")]
        for (index, row) in rows.enumerated() {
            lines.append(line(row))
            if index == rows.count - 1 {
                lines.append(rule("└", "┴", "┘"))
            } else if gridLines || (headerRow && index == 0) {
                lines.append(rule("├", "┼", "┤"))
            }
        }
        return lines.joined(separator: "\n")
    }
}
