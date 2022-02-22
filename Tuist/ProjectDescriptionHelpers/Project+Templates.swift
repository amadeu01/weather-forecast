import ProjectDescription

extension Project {
    /// Helper function to create the Project
    public static func app(
        name: String,
        platform: Platform = .iOS,
        featureTargets: [Target],
        additionalTargets: [TargetDependency] = [],
        resourceSynthesizers: [ResourceSynthesizer] = []
    ) -> Project {
        var appDependencies: [TargetDependency] = []
        appDependencies += additionalTargets

        var targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: appDependencies
        )

        targets += featureTargets

        return Project(
            name: name,
            organizationName: "tuist.io",
            settings: .settings(
                base: [
                    "ENABLE_TESTING_SEARCH_PATHS": "YES"
                ]
            ),
            targets: targets,
            resourceSynthesizers: resourceSynthesizers
        )
    }

    /// Helper function to create a framework target and an associated unit test target
    public static func featureFramework(
        name: String,
        platform: Platform = .iOS,
        dependencies: [TargetDependency] = [],
        testDependencies: [TargetDependency] = [],
        deploymentTarget: ProjectDescription.DeploymentTarget? = nil,
        prodOnly: Bool = false,
        resources: ResourceFileElements? = nil,
        coreDataModels: [CoreDataModel] = []
    ) -> [Target] {
        var targets: [Target] = []

        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: "io.tuist.\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Targets/\(name)/Sources/**"],
            resources: resources,
            dependencies: dependencies,
            coreDataModels: coreDataModels
        )
        targets.append(sources)

        if !prodOnly {
            let tests = Target(
                name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [
                    .target(name: name)
                ] + testDependencies,
                settings: .settings(
                    base: [
                        "ENABLE_TESTING_SEARCH_PATHS": "YES"
                    ]
                )
            )
            targets.append(tests)
        } 
        
        return targets
    }

    /// Helper function to create the application target and the unit test target.
    public static func makeAppTargets(
        name: String,
        platform: Platform = .iOS,
        dependencies: [TargetDependency]
    ) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        return [mainTarget, testTarget]
    }
}

public extension TargetDependency {
    var name: String? {
        if case .target(let targetName) = self {
            return targetName
        }
        if case .external(let targetName) = self {
            return targetName
        }

        return nil
    }
}
