/// The product header and sponsor footer printed by CLIKit-based tools.
public enum Banner {
    /// The product header: `  <name>  v<version>  · <tagline>`.
    public static func bannerLine(name: String, version: String, tagline: String) -> String {
        "  " + Tone.title(name)
            + "  " + Tone.muted("v\(version)")
            + "  " + Tone.subtle("· \(tagline)")
    }

    /// The sponsor footer: `  ♥  Looking for sponsors  <url>`.
    public static func footerLine(url: String) -> String {
        "  " + Tone.love("♥") + "  " + Tone.subtle("Looking for sponsors")
            + "  " + Tone.link(url)
    }

    /// Prints the product header, surrounded by blank lines.
    public static func printBanner(name: String, version: String, tagline: String) {
        print("")
        print(bannerLine(name: name, version: version, tagline: tagline))
        print("")
    }

    /// Prints the sponsor footer, surrounded by blank lines.
    public static func printSponsorFooter(url: String) {
        print("")
        print(footerLine(url: url))
        print("")
    }
}
