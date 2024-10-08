import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

@main
struct HelloLambda: LambdaHandler {
    init(context: LambdaInitializationContext) async throws {}

    func handle(
        _ request: APIGatewayV2Request,
        context: LambdaContext
    ) async throws -> APIGatewayV2Response {
        context.logger.debug("HTTP Method: \(request.context.http.method.rawValue)")
        context.logger.debug("Path: \(request.rawPath)")

        // convert the base64 body to a regular string
        if let base64Body = request.body?.data(using: .utf8),
           let decodedBodyData = Data(base64Encoded: base64Body),
           let decodedBody = String(data: decodedBodyData, encoding: .utf8) {
            context.logger.debug("Body: \(decodedBody)")
        }

        let body = """
{
    "hello": "From Lambda deployed with Swift Cloud",
    "timestamp": "\(Date())",
    "method": "\(request.context.http.method.rawValue)",
    "stage": "\(Lambda.env("stage") ?? "No value")",
    "path": "\(request.rawPath)"
}
"""

        return APIGatewayV2Response(
            statusCode: .ok,
            body: body
        )
    }
}
