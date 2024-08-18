// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "hello",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.70.0"),
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
    // 🗄 An ORM for SQL and NoSQL databases.
    .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
    // 🌱 Fluent driver for Mongo.
    .package(url: "https://github.com/vapor/fluent-mongo-driver.git", from: "1.3.1"),
//    .package(url: "https://github.com/syaifulamindev/jwt-kit.git", branch: "main"),
    .package(url: "https://github.com/syaifulamindev/jwt.git", branch: "main"),
    .package(url: "https://github.com/garanda21/vapor-qrencode.git", from: "1.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentMongoDriver", package: "fluent-mongo-driver"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "NIOPosix", package: "swift-nio"),
        .product(name: "JWT", package: "jwt"),
        .product(name: "QREncode", package: "vapor-qrencode")
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "XCTVapor", package: "vapor"),
      ],
      swiftSettings: swiftSettings
      //            swiftLanguageVersions: [.version("5.10.1")]
    )
  ]
)

var swiftSettings: [SwiftSetting] { [
  .enableUpcomingFeature("DisableOutwardActorInference"),
  .enableExperimentalFeature("StrictConcurrency"),
] }
