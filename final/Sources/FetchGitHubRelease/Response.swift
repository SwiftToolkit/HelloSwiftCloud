import Foundation

struct Response: Codable {
    let success: Bool
    let text: String
    let url: URL?

    init(error: Error) {
        success = false
        text = error.localizedDescription
        url = nil
    }

    init(error: Swift.Error) {
        success = false
        text = error.localizedDescription
        url = nil
    }

    init(handle: String, release: GitHubRelease) {
        success = true
        if release.name != release.tagName {
            text = "Latest \(handle) release: \(release.name) (tag \(release.tagName))"
        } else {
            text = "Latest \(handle) release: \(release.name)"
        }

        url = release.htmlUrl
    }
}
