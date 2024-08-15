import Cloud

@main
struct Project: Cloud.Project {
    func build() async throws -> Outputs {
        let environment = ["stage": Context.current.stage]

        let helloFunction = AWS.Function(
            "HelloLambda",
            targetName: "HelloLambda",
            url: .enabled(),
            memory: 256,
            timeout: .seconds(10),
            environment: environment
        )

        let gitHubReleaseFunction = AWS.Function(
            "FetchGitHubRelease",
            targetName: "FetchGitHubRelease",
            url: .enabled(),
            memory: 256,
            timeout: .seconds(10)
        )

        return Outputs([
            "HelloLambda": helloFunction.url,
            "FetchGitHubRelease": gitHubReleaseFunction.url
        ])
    }
}
