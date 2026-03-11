import XCTest
@testable import MoviePilot

final class MediaModelsTests: XCTestCase {
  func testMediaSearchResponseDecodesItemsFromResultsKey() throws {
    let data = Data("""
    {
      "results": [
        {
          "title": "Inception",
          "media_type": "movie",
          "release_date": "2010-07-16",
          "vote_average": 8.8,
          "tmdb_id": 27205
        }
      ]
    }
    """.utf8)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let response = try decoder.decode(MediaSearchResponse.self, from: data)

    XCTAssertEqual(response.items.count, 1)
    XCTAssertEqual(response.items.first?.displayTitle, "Inception")
    XCTAssertEqual(response.items.first?.stableID, "tmdb-27205")
  }

  func testMediaItemComputedPropertiesPreferExplicitFields() {
    let item = MediaItem(
      id: 7,
      title: nil,
      name: "Interstellar",
      originalTitle: nil,
      year: nil,
      releaseDate: "2014-11-07",
      type: nil,
      mediaType: "movie",
      overview: nil,
      posterPath: "/poster.jpg",
      backdropPath: nil,
      poster: nil,
      backdrop: nil,
      voteAverage: 8.6,
      tmdbId: nil,
      doubanId: nil,
      imdbId: nil,
      season: nil,
      episodes: nil,
      source: nil
    )

    XCTAssertEqual(item.displayTitle, "Interstellar")
    XCTAssertEqual(item.yearText, "2014")
    XCTAssertEqual(item.mediaKind, "movie")
    XCTAssertEqual(item.posterURLString, "/poster.jpg")
    XCTAssertEqual(item.ratingText, "8.6")
    XCTAssertEqual(item.subtitleLine, "movie · 2014")
    XCTAssertEqual(item.stableID, "id-7")
  }

  func testMediaItemStableIDFallsBackToExternalIDs() {
    let item = MediaItem(
      id: nil,
      title: "Spirited Away",
      name: nil,
      originalTitle: nil,
      year: "2001",
      releaseDate: nil,
      type: "anime",
      mediaType: nil,
      overview: nil,
      posterPath: nil,
      backdropPath: nil,
      poster: nil,
      backdrop: nil,
      voteAverage: nil,
      tmdbId: nil,
      doubanId: "1291561",
      imdbId: nil,
      season: nil,
      episodes: nil,
      source: nil
    )

    XCTAssertEqual(item.stableID, "douban-1291561")
  }
}
