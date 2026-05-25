/// Comparison for `vX.Y.Z` version strings.
public enum SemVer {
    /// True when `a` is a newer version than `b`. Splits on `.`, treats a
    /// missing component as 0, tolerates a leading `v`. Pre-release suffixes
    /// (e.g. `-rc1`) are not interpreted.
    public static func isNewer(_ a: String, than b: String) -> Bool {
        let lhs = parts(of: a), rhs = parts(of: b)
        for index in 0..<max(lhs.count, rhs.count) {
            let left = index < lhs.count ? lhs[index] : 0
            let right = index < rhs.count ? rhs[index] : 0
            if left != right { return left > right }
        }
        return false
    }

    private static func parts(of version: String) -> [Int] {
        let trimmed = version.hasPrefix("v") ? String(version.dropFirst()) : version
        return trimmed.split(separator: ".").compactMap { Int($0) }
    }
}
