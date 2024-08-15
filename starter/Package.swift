// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HelloSwiftCloud",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "HelloLambda", targets: ["HelloLambda"]),
        .executable(name: "FetchGitHubRelease", targets: ["FetchGitHubRelease"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "1.0.0-alpha.2"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events.git", branch: "main"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.9.0"),
    ],
    targets: [
        .executableTarget(
            name: "HelloLambda",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            ]
        ),
        .executableTarget(
            name: "FetchGitHubRelease",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]
        ),
    ]
)
