import XCTest
@testable import MoviePilot

final class APIErrorTests: XCTestCase {
  func testDisplayMessageUsesLocalizedErrorDescription() {
    let error = APIError.server("请求失败")

    XCTAssertEqual(error.displayMessage, "请求失败")
  }
}
