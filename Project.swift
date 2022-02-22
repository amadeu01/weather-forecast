import ProjectDescription
import ProjectDescriptionHelpers


func makeFeatureTargets() -> [Target] {
    let deployment: ProjectDescription.DeploymentTarget = .iOS(
        targetVersion: "15.0",
        devices: .iphone
    )

    let ui = Project.featureFramework(
        name: "WeatherForecastUI",
        dependencies: [
            .target(name: "SharedModel"),
            .target(name: "WeatherForecastKit")
        ],
        deploymentTarget: deployment
    )
    
    let apiClient = Project.featureFramework(
        name: "WeatherForecastAPI",
        dependencies: [
            .target(name: "SharedModel"),
            .target(name: "WebClient")
        ],
        testDependencies: [
            .external(name: "Difference"),
            .external(name: "Mocker")
        ],
        deploymentTarget: deployment,
        prodOnly: false
    )

    let webClient = Project.featureFramework(
        name: "WebClient",
        deploymentTarget: deployment,
        prodOnly: true
    )

    let models = Project.featureFramework(
        name: "SharedModel",
        deploymentTarget: deployment,
        prodOnly: true
    )

    let weatherForecastKit = Project.featureFramework(
        name: "WeatherForecastKit",
        dependencies: [
            .target(name: "SharedModel")
        ],
        testDependencies: [
            .external(name: "Difference"),
            .external(name: "Mocker"),
            .external(name: "SnapshotTesting")
        ],
        deploymentTarget: deployment,
        prodOnly: false
    )

    return ui + apiClient + models + webClient + weatherForecastKit
}


let project = Project.app(
    name: "WeatherForecast",
    platform: .iOS,
    featureTargets: makeFeatureTargets(),
    additionalTargets: [
        .target(name: "WeatherForecastUI"),
        .target(name: "WeatherForecastKit")
    ]
)
