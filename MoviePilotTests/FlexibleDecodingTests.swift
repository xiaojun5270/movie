import XCTest
@testable import MoviePilot

final class FlexibleDecodingTests: XCTestCase {
  private var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }

  func testAuthTokenDecodesMixedPrimitiveTypes() throws {
    let data = Data("""
    {
      "access_token": "token-123",
      "token_type": 1,
      "super_user": "true",
      "user_id": "7",
      "user_name": 9527,
      "avatar": 123,
      "level": "9"
    }
    """.utf8)

    let token = try decoder.decode(AuthToken.self, from: data)

    XCTAssertEqual(token.accessToken, "token-123")
    XCTAssertEqual(token.tokenType, "1")
    XCTAssertEqual(token.superUser, true)
    XCTAssertEqual(token.userId, 7)
    XCTAssertEqual(token.userName, "9527")
    XCTAssertEqual(token.avatar, "123")
    XCTAssertEqual(token.level, 9)
  }

  func testCurrentUserDecodesStringAndNumericFlags() throws {
    let data = Data("""
    {
      "id": "12",
      "name": 1001,
      "email": false,
      "is_active": "1",
      "is_superuser": 0,
      "avatar": 99
    }
    """.utf8)

    let user = try decoder.decode(CurrentUser.self, from: data)

    XCTAssertEqual(user.id, 12)
    XCTAssertEqual(user.name, "1001")
    XCTAssertEqual(user.email, "false")
    XCTAssertEqual(user.isActive, true)
    XCTAssertEqual(user.isSuperuser, false)
    XCTAssertEqual(user.avatar, "99")
  }

  func testDownloadItemDecodesNumericAndStringMix() throws {
    let data = Data("""
    {
      "downloader": 1,
      "hash": 9988,
      "title": "Example",
      "year": 2025,
      "size": "1024.5",
      "progress": "66.6",
      "state": true,
      "upspeed": 123,
      "dlspeed": "456 KB/s",
      "left_time": 3600
    }
    """.utf8)

    let item = try decoder.decode(DownloadItem.self, from: data)

    XCTAssertEqual(item.downloader, "1")
    XCTAssertEqual(item.hash, "9988")
    XCTAssertEqual(item.year, "2025")
    XCTAssertEqual(item.size, 1024.5)
    XCTAssertEqual(item.progress, 66.6, accuracy: 0.0001)
    XCTAssertEqual(item.state, "true")
    XCTAssertEqual(item.upspeed, "123")
    XCTAssertEqual(item.leftTime, "3600")
  }

  func testSubscribeItemDecodesNumericStrings() throws {
    let data = Data("""
    {
      "id": "88",
      "name": "Breaking Bad",
      "year": 2008,
      "type": 1,
      "season": "5",
      "poster": 777,
      "vote": "9.7",
      "total_episode": "62",
      "lack_episode": 0,
      "state": true,
      "username": 1000,
      "last_update": 1234567890
    }
    """.utf8)

    let item = try decoder.decode(SubscribeItem.self, from: data)

    XCTAssertEqual(item.id, 88)
    XCTAssertEqual(item.year, "2008")
    XCTAssertEqual(item.type, "1")
    XCTAssertEqual(item.season, 5)
    XCTAssertEqual(item.poster, "777")
    XCTAssertEqual(item.vote, 9.7, accuracy: 0.0001)
    XCTAssertEqual(item.totalEpisode, 62)
    XCTAssertEqual(item.state, "true")
    XCTAssertEqual(item.username, "1000")
    XCTAssertEqual(item.lastUpdate, "1234567890")
  }

  func testMediaSearchResponseDecodesLossyPaginationAndMediaItemFields() throws {
    let data = Data("""
    {
      "page": "2",
      "page_size": "20",
      "total": 101,
      "results": [
        {
          "id": "55",
          "title": 2046,
          "release_date": 2004,
          "media_type": 1,
          "vote_average": "8.2",
          "tmdb_id": "129"
        }
      ]
    }
    """.utf8)

    let response = try decoder.decode(MediaSearchResponse.self, from: data)

    XCTAssertEqual(response.page, 2)
    XCTAssertEqual(response.pageSize, 20)
    XCTAssertEqual(response.total, 101)
    XCTAssertEqual(response.items.first?.id, 55)
    XCTAssertEqual(response.items.first?.displayTitle, "2046")
    XCTAssertEqual(response.items.first?.yearText, "2004")
    XCTAssertEqual(response.items.first?.mediaKind, "1")
    XCTAssertEqual(response.items.first?.ratingText, "8.2")
    XCTAssertEqual(response.items.first?.tmdbId, 129)
  }

  func testMediaDetailDecodesStringArraysFromSingleStringFields() throws {
    let data = Data("""
    {
      "id": "10",
      "title": "The Matrix",
      "year": 1999,
      "media_type": "movie",
      "vote_average": "8.7",
      "genres": "Action, Sci-Fi",
      "countries": "USA/Canada",
      "directors": "Lana Wachowski|Lilly Wachowski",
      "actors": "Keanu Reeves、Carrie-Anne Moss"
    }
    """.utf8)

    let detail = try decoder.decode(MediaDetail.self, from: data)

    XCTAssertEqual(detail.id, 10)
    XCTAssertEqual(detail.yearText, "1999")
    XCTAssertEqual(detail.ratingText, "8.7")
    XCTAssertEqual(detail.genres ?? [], ["Action", "Sci-Fi"])
    XCTAssertEqual(detail.countries ?? [], ["USA", "Canada"])
    XCTAssertEqual(detail.directors ?? [], ["Lana Wachowski", "Lilly Wachowski"])
    XCTAssertEqual(detail.actors ?? [], ["Keanu Reeves", "Carrie-Anne Moss"])
  }
}
