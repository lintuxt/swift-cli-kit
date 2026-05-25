import Darwin

/// ANSI styling, emitted only when stdout is a real terminal — piped or
/// redirected output stays plain so it greps and logs cleanly.
public enum Style {
    public static let useColor: Bool = isatty(fileno(stdout)) != 0

    public static let reset = "\u{1B}[0m"
    public static let bold = "\u{1B}[1m"
    public static let dim = "\u{1B}[2m"

    public static let cyan = "\u{1B}[36m"
    public static let brightCyan = "\u{1B}[96m"
    public static let brightWhite = "\u{1B}[97m"
    public static let green = "\u{1B}[32m"
    public static let yellow = "\u{1B}[33m"
    public static let red = "\u{1B}[31m"
    public static let magenta = "\u{1B}[35m"
    public static let gray = "\u{1B}[90m"

    /// Wraps `text` in the given escape codes — only on a TTY.
    public static func wrap(_ text: String, _ codes: String...) -> String {
        guard useColor else { return text }
        return codes.joined() + text + reset
    }

    /// The visible width of `text`, ignoring any ANSI escape sequences — so
    /// colored cells still align in a table.
    public static func width(of text: String) -> Int {
        guard text.contains("\u{1B}") else { return text.count }
        var visible = 0
        var inEscape = false
        for character in text {
            if inEscape {
                if character == "m" { inEscape = false }
            } else if character == "\u{1B}" {
                inEscape = true
            } else {
                visible += 1
            }
        }
        return visible
    }
}

/// Semantic styled-string builders — call sites read as intent, not ANSI.
public enum Tone {
    public static func title(_ s: String) -> String { Style.wrap(s, Style.bold, Style.brightCyan) }
    public static func heading(_ s: String) -> String { Style.wrap(s, Style.bold) }
    public static func muted(_ s: String) -> String { Style.wrap(s, Style.gray) }
    public static func subtle(_ s: String) -> String { Style.wrap(s, Style.dim) }
    public static func value(_ s: String) -> String { Style.wrap(s, Style.brightWhite) }
    public static func accent(_ s: String) -> String { Style.wrap(s, Style.brightCyan) }
    public static func link(_ s: String) -> String { Style.wrap(s, Style.cyan) }
    public static func ok(_ s: String) -> String { Style.wrap(s, Style.green) }
    public static func warn(_ s: String) -> String { Style.wrap(s, Style.yellow) }
    public static func error(_ s: String) -> String { Style.wrap(s, Style.red) }
    public static func love(_ s: String) -> String { Style.wrap(s, Style.magenta) }
}
