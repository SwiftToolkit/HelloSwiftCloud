import AsyncHTTPClient
import HTTPTypes
import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

@main
struct FetchGitHubRelease: LambdaHandler {
    init(context: LambdaInitializationContext) async throws {}

    func handle(
        _ request: APIGatewayV2Request,
        context: LambdaContext
    ) async throws -> APIGatewayV2Response {
        var handle = request.rawPath

        if handle.hasPrefix("/") {
            handle = String(handle.dropFirst())
        }

        guard handle.components(separatedBy: "/").count == 2 else {
            return APIGatewayV2Response(
                statusCode: .badRequest,
                content: Response(error: .invalidRepoHandle(handle))
            )
        }

        do {
            let release = try await fetchLatestGitHubRelease(for: handle, context: context)
            let response = Response(handle: handle, release: release)
            return APIGatewayV2Response(statusCode: .ok, content: response)
        } catch let error as Error {
            return APIGatewayV2Response(statusCode: .badRequest, content: Response(error: error))
        } catch {
            return APIGatewayV2Response(statusCode: .internalServerError, content: Response(error: error))
        }
    }

    private func fetchLatestGitHubRelease(
        for repoHandle: String,
        context: LambdaContext
    ) async throws -> GitHubRelease {
        let urlString = "https://api.github.com/repos/\(repoHandle)/releases/latest"

        context.logger.debug("Fetching latest GitHub release for \(repoHandle)")
        context.logger.debug("URL: \(urlString)")

        var request = HTTPClientRequest(url: urlString)
        request.headers = ["User-Agent": "Swift-GitHub-Release-Fetcher"]
        let response = try await HTTPClient.shared.execute(request, timeout: .seconds(30))

        let body = try await response.body.collect(upTo: 1024 * 1024) // 1 MB

        guard response.status == .ok else {
            throw Error.invalidResponse(.init(code: Int(response.status.code)), String(buffer: body))
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GitHubRelease.self, from: body)
    }
}

struct GitHubRelease: Codable {
    let tagName: String
    let name: String
    let htmlUrl: URL
}
