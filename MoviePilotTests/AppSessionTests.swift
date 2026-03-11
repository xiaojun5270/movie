import XCTest
@testable import MoviePilot

@MainActor
final class AppSessionTests: XCTestCase {
  private var defaults: UserDefaults!
  private var suiteName: String!

  override func setUp() {
    super.setUp()
    suiteName = "MoviePilotTests.\(UUID().uuidString)"
    defaults = UserDefaults(suiteName: suiteName)
  }

  override func tearDown() {
    if let suiteName {
      defaults?.removePersistentDomain(forName: suiteName)
    }
    defaults = nil
    suiteName = nil
    super.tearDown()
  }

  func testBootstrapLoadsCurrentUserFromStoredCredentials() async {
    defaults.set("http://127.0.0.1:3001", forKey: AppConfig.serverURLKey)
    let keychain = RecordingKeychainStore(storedValues: [AppConfig.tokenKey: "stored-token"])
    let api = StubMoviePilotAPI(baseURL: "http://127.0.0.1:3001", token: "stored-token")
    api.currentUserResult = .success(CurrentUser(id: 1, name: "Tester", email: nil, isActive: true, isSuperuser: true, avatar: nil))

    let session = AppSession(
      defaults: defaults,
      keychain: keychain,
      apiFactory: { _, _ in api }
    )

    await session.bootstrap()

    XCTAssertEqual(session.currentUser?.name, "Tester")
    XCTAssertEqual(session.token, "stored-token")
    XCTAssertNil(session.lastError)
    XCTAssertFalse(session.isBootstrapping)
  }

  func testBootstrapFailureLogsOutAndKeepsServerURL() async {
    defaults.set("http://127.0.0.1:3001", forKey: AppConfig.serverURLKey)
    let keychain = RecordingKeychainStore(storedValues: [AppConfig.tokenKey: "expired-token"])
    let api = StubMoviePilotAPI(baseURL: "http://127.0.0.1:3001", token: "expired-token")
    api.currentUserResult = .failure(APIError.unauthorized)

    let session = AppSession(
      defaults: defaults,
      keychain: keychain,
      apiFactory: { _, _ in api }
    )

    await session.bootstrap()

    XCTAssertNil(session.currentUser)
    XCTAssertNil(session.token)
    XCTAssertEqual(session.serverURL, "http://127.0.0.1:3001")
    XCTAssertEqual(session.lastError, APIError.unauthorized.errorDescription)
    XCTAssertEqual(keychain.deletedKeys, [AppConfig.tokenKey])
  }

  func testLoginStoresTokenUserAndUsername() async throws {
    let keychain = RecordingKeychainStore()
    let authAPI = StubMoviePilotAPI(baseURL: "http://127.0.0.1:3001", token: nil)
    authAPI.loginResult = .success(
      AuthToken(
        accessToken: "token-123",
        tokenType: "bearer",
        superUser: true,
        userId: 7,
        userName: "tester",
        avatar: nil,
        level: 1
      )
    )

    let authedAPI = StubMoviePilotAPI(baseURL: "http://127.0.0.1:3001", token: "token-123")
    authedAPI.currentUserResult = .success(CurrentUser(id: 7, name: "tester", email: nil, isActive: true, isSuperuser: true, avatar: nil))

    let session = AppSession(
      defaults: defaults,
      keychain: keychain,
      apiFactory: { _, token in
        token == nil ? authAPI : authedAPI
      }
    )

    try await session.login(serverURL: " http://127.0.0.1:3001/ ", username: "tester", password: "secret")

    XCTAssertEqual(session.serverURL, "http://127.0.0.1:3001")
    XCTAssertEqual(session.token, "token-123")
    XCTAssertEqual(session.currentUser?.id, 7)
    XCTAssertEqual(defaults.string(forKey: AppConfig.serverURLKey), "http://127.0.0.1:3001")
    XCTAssertEqual(defaults.string(forKey: AppConfig.usernameKey), "tester")
    XCTAssertEqual(keychain.savedValues[AppConfig.tokenKey], "token-123")
    XCTAssertEqual(authAPI.loginCalls, [("tester", "secret")])
    XCTAssertEqual(authedAPI.currentUserCallCount, 1)
  }

  func testLogoutClearsStoredStateWhenRequested() async throws {
    defaults.set("http://127.0.0.1:3001", forKey: AppConfig.serverURLKey)
    defaults.set("tester", forKey: AppConfig.usernameKey)
    let keychain = RecordingKeychainStore(storedValues: [AppConfig.tokenKey: "token-123"])
    let session = AppSession(defaults: defaults, keychain: keychain)

    session.logout(keepServer: false)

    XCTAssertNil(session.token)
    XCTAssertNil(session.currentUser)
    XCTAssertEqual(session.serverURL, "")
    XCTAssertNil(defaults.string(forKey: AppConfig.serverURLKey))
    XCTAssertEqual(keychain.deletedKeys, [AppConfig.tokenKey])
  }
}

private final class RecordingKeychainStore: KeychainStore {
  private(set) var savedValues: [String: String]
  private(set) var deletedKeys: [String] = []

  init(storedValues: [String: String] = [:]) {
    self.savedValues = storedValues
    super.init(service: "tests")
  }

  override func save(_ value: String, for key: String) {
    savedValues[key] = value
  }

  override func readString(for key: String) -> String? {
    savedValues[key]
  }

  override func deleteValue(for key: String) {
    deletedKeys.append(key)
    savedValues.removeValue(forKey: key)
  }
}

private final class StubMoviePilotAPI: MoviePilotAPI {
  var loginResult: Result<AuthToken, Error>?
  var currentUserResult: Result<CurrentUser, Error>?
  private(set) var loginCalls: [(String, String)] = []
  private(set) var currentUserCallCount = 0

  override func login(username: String, password: String) async throws -> AuthToken {
    loginCalls.append((username, password))
    guard let loginResult else {
      XCTFail("Missing loginResult stub")
      throw APIError.server("Missing loginResult stub")
    }
    return try loginResult.get()
  }

  override func currentUser() async throws -> CurrentUser {
    currentUserCallCount += 1
    guard let currentUserResult else {
      XCTFail("Missing currentUserResult stub")
      throw APIError.server("Missing currentUserResult stub")
    }
    return try currentUserResult.get()
  }
}
