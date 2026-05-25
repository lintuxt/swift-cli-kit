import Foundation

/// An upgrade-flow failure whose message is meant to be shown to the user.
public struct UpgradeError: Error, CustomStringConvertible {
    public let description: String
    public init(_ description: String) { self.description = description }
}

/// A generic GitHub-release self-update flow: check the latest release tag,
/// compare it against the running version, and re-run the project's
/// `install.sh` when a newer release exists.
public enum Upgrade {
    /// async core — for `async @main` CLIs (e.g. solcito).
    ///
    /// `currentVersion` must be a bare version number without a leading `v`
    /// (e.g. `"0.1.2"`, not `"v0.1.2"`).
    public static func run(repo: String, currentVersion: String, installerURL: String) async throws {
        print("")
        print("  " + Tone.heading("Checking for updates…"))

        let latest = try await fetchLatestTag(repo: repo)
        let current = "v" + currentVersion
        print("  " + Tone.subtle("installed \(current)   ·   latest \(latest)"))
        print("")

        guard SemVer.isNewer(latest, than: current) else {
            print("  " + Tone.ok("✓") + "  " + Tone.value("You're on the latest version."))
            print("")
            return
        }

        print("  " + Tone.heading("Upgrading to \(latest)…"))
        print("")
        try runInstaller(installerURL: installerURL)
        print("")
        print("  " + Tone.ok("✓") + "  " + Tone.value("Upgraded to \(latest)."))
        print("")
    }

    /// Synchronous wrapper — for `ParsableCommand.run()` CLIs (e.g.
    /// displayswitcher). Bridges the async core with a semaphore.
    public static func runSync(repo: String, currentVersion: String, installerURL: String) throws {
        let box = Box<Error?>(nil)
        let semaphore = DispatchSemaphore(value: 0)
        Task.detached {
            do {
                try await run(repo: repo, currentVersion: currentVersion, installerURL: installerURL)
            } catch {
                box.value = error
            }
            semaphore.signal()
        }
        semaphore.wait()
        if let error = box.value { throw error }
    }

    /// Extracts `tag_name` from a GitHub "latest release" JSON payload.
    static func parseTag(from data: Data) throws -> String {
        guard let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let tag = object["tag_name"] as? String, !tag.isEmpty
        else {
            throw UpgradeError("GitHub's response didn't include a release tag.")
        }
        return tag
    }

    /// One blocking GET against the GitHub API for the latest release tag.
    private static func fetchLatestTag(repo: String) async throws -> String {
        let url = URL(string: "https://api.github.com/repos/\(repo)/releases/latest")!
        var request = URLRequest(url: url)
        request.setValue("swift-cli-kit", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 10
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(for: request)
        } catch {
            throw UpgradeError("Couldn't reach GitHub to check for updates. "
                               + "(\(error.localizedDescription))")
        }
        return try parseTag(from: data)
    }

    /// Re-runs the canonical installer, inheriting this terminal so its
    /// colored progress (and any sudo prompt) appears as normal.
    private static func runInstaller(installerURL: String) throws {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        task.arguments = ["-c", #"curl -fsSL -- "$1" | sh"#, "--", installerURL]
        do {
            try task.run()
            task.waitUntilExit()
        } catch {
            throw UpgradeError("Couldn't run the installer. (\(error.localizedDescription))")
        }
        guard task.terminationStatus == 0 else {
            throw UpgradeError("The installer exited with status \(task.terminationStatus).")
        }
    }
}

/// A reference box used to carry a value out of the bridging `Task` in
/// `runSync`. The `DispatchSemaphore` provides the happens-before ordering,
/// so the unchecked `Sendable` conformance is safe.
private final class Box<T>: @unchecked Sendable {
    var value: T
    init(_ value: T) { self.value = value }
}
