// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// The 'var targets: [Target] = [...]' definition you have is mostly okay,
// but we need to correct the 'RabbitMq' target's dependencies within it.
// The executable targets for examples and the test target can remain for now,
// but ensure their dependencies are also valid.

// Corrected RabbitMq target definition (part of your 'var targets' array)
// Ensure this specific part of your 'var targets' array is updated:
/*
    .target(
        name: "RabbitMq",
        dependencies: [
            .product(name: "AMQPClient", package: "rabbitmq-nio"),
            // REMOVE .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"), // Not in official 0.3.1 lib target
            .product(name: "Logging", package: "swift-log"),
            .product(name: "Lifecycle", package: "swift-service-lifecycle"), // CORRECTED product name
            .product(name: "Semaphore", package: "semaphore"),
        ]
    ),
*/

// --- Then, further down, for the main 'let package = Package(...)' ---

let package = Package(
    name: "swift-rabbitmq",
    platforms: [ // Align with official 0.3.1 tag to reduce variables
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(name: "RabbitMq", targets: ["RabbitMq"])
    ],
    dependencies: [
        // These are the dependencies from the official 0.3.1 tag, plus your rabbitmq-nio fix
        .package(url: "https://github.com/funcmike/rabbitmq-nio.git", from: "0.5.0"), // YOUR CRUCIAL FIX
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4"),
        .package(url: "https://github.com/groue/Semaphore.git", from: "0.1.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.8.0"),
        // If swift-async-algorithms is needed by your examples or tests, it can be here.
        // For now, let's try without it in the main package dependencies if the library itself doesn't need it.
        // It's often pulled in transitively by other Apple libraries if needed.
        // .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),

        // Remove these for now to simplify resolution for the core library:
        // .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
        // .package(url: "https://github.com/xtremekforever/testcontainers-swift.git", branch: "main"),
    ],
    // Your 'targets: targets' line at the end is fine, assuming the 'var targets'
    // array above it has the 'RabbitMq' target correctly defined.
    targets: [ // Redefining targets here for clarity based on simplified dependencies
        .target(
            name: "RabbitMq",
            dependencies: [
                .product(name: "AMQPClient", package: "rabbitmq-nio"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Lifecycle", package: "swift-service-lifecycle"), // CORRECTED product name
                .product(name: "Semaphore", package: "semaphore")
                // If your library code for RabbitMq *directly* uses AsyncAlgorithms, add it here:
                // .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
                // and also add swift-async-algorithms to the package dependencies list above.
            ]
        ),
        // You can keep your example and test targets if you wish,
        // but ensure their dependencies are also resolvable.
        // For now, focusing on getting the main "RabbitMq" library target to resolve.
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
        // Test target can be included if testcontainers-swift is also in package dependencies
        // For now, you might comment out the test target and its dependency on testcontainers-swift
        // just to simplify the initial resolution.
        /*
        #if canImport(Testing)
            .testTarget(
                name: "Tests",
                dependencies: [
                    "RabbitMq",
                    // .product(name: "Testcontainers", package: "testcontainers-swift"),
                ]
            )
        #endif
        */
    ]
)