// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GameBackend",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
            ],
            path: "Sources/App",
            // Исключаем dev-варианты, чтобы не было дублирования configure/routes и лишних ошибок
            exclude: [
                "configure-Development.swift",
                "routes-Development.swift"
            ]
        ),
        .executableTarget(
            name: "Run",
            dependencies: [.target(name: "App")],
            path: "Sources/Run",
            // Исключаем дополнительные демо main-файлы SwiftNIO
            exclude: [
                "main-NIOHTTP1Server.swift",
                "main-NIOHTTP2PerformanceTester.swift",
                "main-NIOUDPEchoClient.swift"
            ]
        )
    ]
)
