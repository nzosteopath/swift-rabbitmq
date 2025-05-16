// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "swift-rabbitmq",
    platforms: [ // Using official 0.3.1 platforms
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(name: "RabbitMq", targets: ["RabbitMq"])
    ],
    dependencies: [
        // Pointing to your fork of rabbitmq-nio on the branch you created
        .package(url: "https://github.com/nzosteopath/rabbitmq-nio.git", branch: "my-nio-for-swift-rabbitmq"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4"),
        .package(url: "https://github.com/groue/Semaphore.git", from: "0.1.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", exact: "2.8.0")
        // Temporarily remove swift-async-algorithms from here if it was listed
    ],
    targets: [
        .target(
            name: "RabbitMq",
            dependencies: [
                .product(name: "AMQPClient", package: "rabbitmq-nio"), // Name from your rabbitmq-nio fork's Package.swift
                .product(name: "Logging", package: "swift-log"),
				.product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                //.product(name: "Lifecycle", package: "swift-service-lifecycle"),
                .product(name: "Semaphore", package: "semaphore")
                // Temporarily remove .product(name: "AsyncAlgorithms", package: "swift-async-algorithms") from here
            ]
        ),
        // You can keep your example and test targets, but they might also fail 
        // if they depend on AsyncAlgorithms and it can't be fetched.
        // For now, focus on getting the main "RabbitMq" library target to resolve.
        .executableTarget(
            name: "BasicConsumePublish",
            dependencies: ["RabbitMq"],
            path: "Sources/Examples/BasicConsumePublish"
        ),
        .executableTarget(
            name: "ConsumePublishServices",
            dependencies: ["RabbitMq"],
            path: "Sources/Examples/ConsumePublishServices"
        ),
        // You might want to temporarily comment out the test target if it adds complexity
        /*
        #if canImport(Testing)
            .testTarget(
                name: "Tests",
                dependencies: [ "RabbitMq" ] // Removed testcontainers for simplicity for now
            )
        #endif
        */
    ]
)