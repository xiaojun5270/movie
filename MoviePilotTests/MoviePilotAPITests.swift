import XCTest
@testable import MoviePilot

final class MoviePilotAPITests: XCTestCase {
  override func tearDown() {
    URLProtocolStub.requestHandler = nil
    super.tearDown()
  }

  func testLoginUsesOfficialPathAndFormEncoding() async throws {
    let session = TestURLSessionFactory.makeSession()
    let client = NetworkClient(baseURL: "http://127.0.0.1:3001", token: nil, session: session)
    let api = MoviePilotAPI(client: client)

    URLProtocolStub.requestHandler = { request in
      XCTAssertEqual(request.httpMethod, "POST")
      XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:3001/api/v1/login/access-token")
      XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")

      let body = try XCTUnwrap(String(data: try XCTUnwrap(request.httpBody), encoding: .utf8))
      XCTAssertEqual(body, "username=tester&password=p@ss%20word")

      let data = Data("""
      {
        "access_token": "token-123",
        "token_type": "bearer",
        "super_user": true,
        "user_id": 7,
        "user_name": "tester",
        "avatar": null,
        "level": 1
      }
      """.utf8)
      let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, data)
    }

    let token = try await api.login(username: "tester", password: "p@ss word")

    XCTAssertEqual(token.accessToken, "token-123")
    XCTAssertEqual(token.userId, 7)
  }

  func testCurrentUserUsesAuthorizationHeader() async throws {
    let session = TestURLSessionFactory.makeSession()
    let client = NetworkClient(baseURL: "http://127.0.0.1:3001", token: "token-123", session: session)
    let api = MoviePilotAPI(client: client)

    URLProtocolStub.requestHandler = { request in
      XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:3001/api/v1/user/current")
      XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token-123")

      let data = Data("""
      {
        "id": 7,
        "name": "tester",
        "is_superuser": false
      }
      """.utf8)
      let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, data)
    }

    let user = try await api.currentUser()

    XCTAssertEqual(user.id, 7)
    XCTAssertEqual(user.name, "tester")
  }
}
