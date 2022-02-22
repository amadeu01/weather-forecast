import ProjectDescription

let dependencies = Dependencies(
    carthage: [
        .github(
            path: "https://github.com/pointfreeco/swift-snapshot-testing",
            requirement: .branch("main")
        )
    ],
    swiftPackageManager: .init(
        [
            .remote(
                url: "https://github.com/WeTransfer/Mocker.git",
                requirement: .upToNextMajor(from: "2.3.0")
            ),
            .remote(
                url: "https://github.com/krzysztofzablocki/Difference.git",
                requirement: .upToNextMajor(from: "1.0.0")
            )
        ],
        baseSettings: .settings(
            base: ["ENABLE_TESTING_SEARCH_PATHS": "YES"]
        )
    ),
    platforms: [.iOS]
)
