// swift-tools-version: 6.4

import PackageDescription

// swift-agent-skills — parsing and validating canonical agent-skill
// documents.
//
// The Skill Validation target is the Institute's sole owner of the
// agent-skill document contract: closed YAML frontmatter carrying only
// `name` and `description`, a non-empty body, and the canonical limits.
// The Codex/ChatGPT projection and the Institute Application coordinator
// are consumers; policy about where skills live belongs to them, never
// here.
let package = Package(
    name: "swift-agent-skills",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Skill Validation",
            targets: ["Skill Validation"]
        )
    ],
    targets: [
        .target(
            name: "Skill Validation"
        ),
        .testTarget(
            name: "Skill Validation Tests",
            dependencies: [
                .target(name: "Skill Validation")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
