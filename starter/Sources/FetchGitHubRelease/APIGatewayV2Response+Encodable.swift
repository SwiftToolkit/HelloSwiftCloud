import AWSLambdaEvents
import Foundation
import HTTPTypes

private let defaultEncoder = JSONEncoder()

extension APIGatewayV2Response {
    init(
        statusCode: HTTPResponse.Status,
        jsonEncoder: JSONEncoder = defaultEncoder,
        content: some Encodable
    ) {
        do {
            let data = try jsonEncoder.encode(content)
            let string = String(data: data, encoding: .utf8)
            self.init(statusCode: statusCode, body: string)
        } catch {
            if let data = try? jsonEncoder.encode(content) {
                let string = String(data: data, encoding: .utf8)
                self.init(statusCode: .preconditionFailed, body: string)
            } else {
                self.init(statusCode: .preconditionFailed, body: "Plain Error: \(error)")
            }
        }
    }
}
