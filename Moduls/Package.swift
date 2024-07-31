// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Moduls",
    platforms: [.iOS(.v17)],
    products: [
        
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
        
        .library(
            name: "MatchMakerAuthentication",
            targets: ["MatchMakerAuthentication"]),
        
        .library(
            name: "MatchMakerCore",
            targets: ["MatchMakerCore"]),
        
        .library(
            name: "MatchMakerLogin",
            targets: ["MatchMakerLogin"]),
        
        .library(
            name: "MatchMakerSettings",
            targets: ["MatchMakerSettings"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.29.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
    ],
    
    targets: [
        .target(
            name: "DesignSystem",
            resources: [
                .process("Resources")
            ]),
        
        .target(
            name: "MatchMakerAuthentication",
            dependencies: [
                .product(
                    name: "FirebaseAuth",
                    package: "firebase-ios-sdk")
            ]),
        
        .target(name: "MatchMakerCore"),
        
        .target(
            name: "MatchMakerLogin",
            dependencies: [
                "DesignSystem",
                "MatchMakerAuthentication",
                "MatchMakerCore",
                "MatchMakerSettings",
                "SnapKit",
                "PhoneNumberKit"],
            resources: [
                .process("Resources")]
        ),
        
        .target(
            name: "MatchMakerSettings",
            dependencies: [
                "DesignSystem",
                "MatchMakerCore",
                "MatchMakerAuthentication",
                "SnapKit",
                "SDWebImage",
                .product(
                    name: "FirebaseAuth",
                    package: "firebase-ios-sdk"),
                .product(
                    name: "FirebaseStorage",
                    package: "firebase-ios-sdk"),
                .product(
                    name: "FirebaseDatabase",
                    package: "firebase-ios-sdk")],
            resources: [
                .process("Resources")]
        )
    ]
)
