import XCTest
@testable import MoviePilot

final class AppConfigTests: XCTestCase {
  func testOfficialDevelopmentDefaultsMatchConfiguredValues() {
    XCTAssertEqual(AppConfig.apiPathPrefix, "/api/v1")
    XCTAssertEqual(AppConfig.defaultDevelopmentServerURL, "http://127.0.0.1:3001")
  }

  func testNormalizedServerURLTrimsWhitespaceAndTrailingSlashes() {
    let raw = "  https://moviepilot.example.com///  "

    XCTAssertEqual(raw.normalizedServerURL, "https://moviepilot.example.com")
  }

  func testNormalizedServerURLKeepsInnerPath() {
    let raw = "http://192.168.1.10:3000/api"

    XCTAssertEqual(raw.normalizedServerURL, "http://192.168.1.10:3000/api")
  }
}
