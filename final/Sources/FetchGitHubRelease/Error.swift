import Foundation
import HTTPTypes

enum Error: Swift.Error {
    case invalidRepoHandle(String)
    case invalidResponse(HTTPResponse.Status, String)
}

extension Error: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .invalidRepoHandle(handle):
            "Invalid response with status: \(handle)"
        case let .invalidResponse(status, body):
            "Invalid response from GitHub with status (\(status)): \(body)"
        }
    }
}
