// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Transport",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "TransportHome",
      targets: ["TransportHome"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/DevYeom/ModernRIBs", exact: "1.0.1"),
    .package(path: "../Finance")
  ],
  targets: [
    .target(
      name: "TransportHome",
      dependencies: [
        "ModernRIBs",
        .product(name: "FinanceRepository", package: "Finance"),
        .product(name: "Topup", package: "Finance"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
  ]
)
