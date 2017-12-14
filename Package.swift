import PackageDescription

let package = Package(
  name: "Novel",
  targets: [
    Target(name: "Demo", dependencies: ["NovelCore", "NovelAdmin", "NovelAPI", "NovelTheme"]),
    Target(name: "NovelTheme", dependencies: ["NovelCore"]),
    Target(name: "NovelAPI", dependencies: ["NovelCore"]),
    Target(name: "NovelAdmin", dependencies: ["NovelCore"]),
    Target(name: "NovelCore"),
  ],
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1),
    .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
    .Package(url: "https://github.com/vapor-community/postgresql-provider.git", majorVersion: 2),
    .Package(url: "https://github.com/vapor/auth-provider.git", majorVersion: 1)
  ],
  exclude: [
    "Config",
    "Database",
    "Localization",
    "Public",
    "Resources"
  ]
)
