// Created by Cal Stephens on 12/15/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

// MARK: - SnapshotConfiguration

/// Snapshot configuration for an individual test case
struct SnapshotConfiguration {
  /// The precision that should be used when comparing the
  /// captured snapshot with the reference image in `Tests/__Snapshots`
  ///  - Defaults to 1.0 (the snapshot must match exactly).
  ///  - This can be lowered for snapshots that render somewhat nondeterministically,
  ///    but should be kept as high as possible (while still permitting the diff to succeed)
  var precision: Float = 1

  /// Whether or not this snapshot should be tested using the experimental rendering engine
  ///  - Defaults to false, since the experimental rendering engine
  ///    currently supports a relatively small number of animations.
  var testWithExperimentalRenderingEngine = false
}

// MARK: Custom mapping

extension SnapshotConfiguration {
  /// Custom configurations for individual snapshot tests that
  /// cannot use the default configuration
  static let customMapping: [String: SnapshotConfiguration] = [
    /// These samples appear to render in a slightly non-deterministic way,
    /// depending on the test environment, so we have to decrease precision a bit.
    "Issues/issue_1407": .precision(0.9),
    "Nonanimating/FirstText": .precision(0.99),
    "Nonanimating/verifyLineHeight": .precision(0.99),

    /// These samples are known to be supported by the experimental rendering engine
    "PinJump": .testWithExperimentalRenderingEngine,
    "Switch": .testWithExperimentalRenderingEngine,
    "Switch_States": .testWithExperimentalRenderingEngine,
    "TwitterHeart": .testWithExperimentalRenderingEngine,
    "TwitterHeartButton": .testWithExperimentalRenderingEngine,
    "HamburgerArrow": .testWithExperimentalRenderingEngine,
    "vcTransition2": .testWithExperimentalRenderingEngine,
    "Nonanimating/Zoom": .testWithExperimentalRenderingEngine,
    "Nonanimating/GeometryTransformTest": .testWithExperimentalRenderingEngine,
    "LottieFiles/loading_dots_1": .testWithExperimentalRenderingEngine,
    "LottieFiles/loading_dots_2": .testWithExperimentalRenderingEngine,
    "LottieFiles/loading_dots_3": .testWithExperimentalRenderingEngine,

    // These samples are not quite perfect yet, but are looking pretty good:
    "9squares_AlBoardman": .testWithExperimentalRenderingEngine,
    "vcTransition1": .testWithExperimentalRenderingEngine,
    "LottieLogo1_masked": .testWithExperimentalRenderingEngine,
    "MotionCorpse_Jrcanest": .testWithExperimentalRenderingEngine,
  ]
}

// MARK: Helpers

extension SnapshotConfiguration {
  /// The default configuration to use if no custom mapping is provided
  static let `default` = SnapshotConfiguration()

  /// The default configuration to use for samples in `Samples/Private`
  static let defaultForPrivateSamples = SnapshotConfiguration.testWithExperimentalRenderingEngine

  /// A `SnapshotConfiguration` value with `testWithExperimentalRenderingEngine` customized to `true`
  static var testWithExperimentalRenderingEngine: SnapshotConfiguration {
    var configuration = SnapshotConfiguration.default
    configuration.testWithExperimentalRenderingEngine = true
    return configuration
  }

  /// The `SnapshotConfiguration` to use for the given sample JSON file name
  static func forSample(named sampleName: String) -> SnapshotConfiguration {
    if let customConfiguration = customMapping[sampleName] {
      return customConfiguration
    } else if sampleName.hasPrefix("Private/") {
      return .defaultForPrivateSamples
    } else {
      return .default
    }
  }

  /// A `SnapshotConfiguration` value with `precision` customized to the given value
  static func precision(_ precision: Float) -> SnapshotConfiguration {
    var configuration = SnapshotConfiguration.default
    configuration.precision = precision
    return configuration
  }
}