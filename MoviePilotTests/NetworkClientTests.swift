import XCTest
@testable import MoviePilot

final class NetworkClientTests: XCTestCase {
  override func tearDown() {
    URLProtocolStub.requestHandler = nil
    super.tearDown()
  }

  func testSendBuildsQueryAuthorizationAndDecodesSnakeCase() async throws {
    let session = TestURLSessionFactory.makeSession()
    let client = NetworkClient(baseURL: "http://127.0.0.1:3001/", token: "secret", session: session)

    URLProtocolStub.requestHandler = { request in
      XCTAssertEqual(request.httpMethod, "GET")
      XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer secret")
      XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:3001/api/v1/user/current?with_team=true")

      let data = Data("""
      {
        "id": 1,
        "name": "MoviePilot",
        "is_superuser": true
      }
      """.utf8)

      let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, data)
    }

    let user = try await client.send(
      RequestSpec(
        path: "/api/v1/user/current",
        queryItems: [URLQueryItem(name: "with_team", value: "true")]
      ),
      as: CurrentUser.self
    )

    XCTAssertEqual(user.id, 1)
    XCTAssertEqual(user.name, "MoviePilot")
    XCTAssertEqual(user.isSuperuser, true)
  }

  func testSendThrowsUnauthorizedFor401() async {
    let session = TestURLSessionFactory.makeSession()
    let client = NetworkClient(baseURL: "http://127.0.0.1:3001", token: nil, session: session)

    URLProtocolStub.requestHandler = { request in
      let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 401, httpVersion: nil, headerFields: nil)!
      return (response, Data())
    }

    do {
      _ = try await client.send(RequestSpec(path: "/api/v1/user/current"), as: CurrentUser.self)
      XCTFail("Expected unauthorized error")
    } catch let error as APIError {
      XCTAssertEqual(error.errorDescription, APIError.unauthorized.errorDescription)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func testSendUsesEnvelopeMessageForServerErrors() async {
    let session = TestURLSessionFactory.makeSession()
    let client = NetworkClient(baseURL: "http://127.0.0.1:3001", token: nil, session: session)

    URLProtocolStub.requestHandler = { request in
      let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 500, httpVersion: nil, headerFields: nil)!
      let data = Data("""
      {
        "success": false,
        "message": "服务异常"
      }
      """.utf8)
      return (response, data)
    }

    do {
      _ = try await client.send(RequestSpec(path: "/api/v1/user/current"), as: CurrentUser.self)
      XCTFail("Expected server error")
    } catch let error as APIError {
      XCTAssertEqual(error.errorDescription, "服务异常")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
