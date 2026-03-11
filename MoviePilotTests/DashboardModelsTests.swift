import XCTest
@testable import MoviePilot

final class DashboardModelsTests: XCTestCase {
  func testUsageRatioReturnsZeroWhenTotalIsMissing() {
    let storage = StorageInfo(totalStorage: nil, usedStorage: 50)

    XCTAssertEqual(storage.usageRatio, 0)
  }

  func testUsageRatioReturnsZeroWhenTotalIsZero() {
    let storage = StorageInfo(totalStorage: 0, usedStorage: 50)

    XCTAssertEqual(storage.usageRatio, 0)
  }

  func testUsageRatioCalculatesExpectedValue() {
    let storage = StorageInfo(totalStorage: 200, usedStorage: 50)

    XCTAssertEqual(storage.usageRatio, 0.25, accuracy: 0.0001)
  }
}
