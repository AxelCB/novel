// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Novel",
  products: [
      .executable(name: "Demo", targets: ["Demo"]),
      .library(name: "NovelTheme", targets: ["NovelTheme"]),
      .library(name: "NovelAPI", targets: ["NovelAPI"]),
      .library(name: "NovelAdmin", targets: ["NovelAdmin"]),
      .library(name: "NovelCore", targets:["NovelCore"]),
  ],
  dependencies: [
      .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.0.0")),
      .package(url: "https://github.com/vapor/leaf-provider.git", .upToNextMajor(from: "1.0.0")),
      .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.0.0")),
      .package(url: "https://github.com/vapor-community/postgresql-provider.git", .upToNextMajor(from: "2.0.0")),
      .package(url: "https://github.com/vapor/auth-provider.git", .upToNextMajor(from: "1.0.0")),
      .package(url: "https://github.com/vapor/validation-provider.git", .upToNextMajor(from: "1.0.0"))
  ],
  targets: [
      .target(name: "Demo", dependencies: ["NovelCore", "NovelAdmin", "NovelAPI", "NovelTheme"]),
      .target(name: "NovelTheme", dependencies: ["NovelCore"], exclude: ["Config","Database","Localization","Public","Resources"]),
      .target(name: "NovelAPI", dependencies: ["NovelCore"], exclude: ["Config","Database","Localization","Public","Resources"]),
      .target(name: "NovelAdmin", dependencies: ["NovelCore"], exclude: ["Config","Database","Localization","Public","Resources"]),
      .target(name: "NovelCore", dependencies: ["Vapor", "LeafProvider", "PostgreSQLProvider", "ValidationProvider", "AuthProvider"], exclude: ["Config","Database","Localization","Public","Resources"]),
  ]
)
