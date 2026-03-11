import Foundation

struct MediaSearchResponse: Decodable {
 let page: Int?
 let pageSize: Int?
 let total: Int?
 let items: [MediaItem]

 enum CodingKeys: String, CodingKey {
 case page
 case pageSize
 case total
 case items
 case list
 case results
 case data
 }

 init(from decoder: Decoder) throws {
 let container = try decoder.container(keyedBy: CodingKeys.self)
 page = try container.decodeLossyInt(forKey: .page)
 pageSize = try container.decodeLossyInt(forKey: .pageSize)
 total = try container.decodeLossyInt(forKey: .total)
 if let items = try container.decodeIfPresent([MediaItem].self, forKey: .items) {
 self.items = items
 } else if let items = try container.decodeIfPresent([MediaItem].self, forKey: .list) {
 self.items = items
 } else if let items = try container.decodeIfPresent([MediaItem].self, forKey: .results) {
 self.items = items
 } else if let items = try container.decodeIfPresent([MediaItem].self, forKey: .data) {
 self.items = items
 } else {
 self.items = []
 }
 }
}

struct MediaItem: Identifiable, Decodable {
 let id: Int?
 let title: String?
 let name: String?
 let originalTitle: String?
 let year: String?
 let releaseDate: String?
 let type: String?
 let mediaType: String?
 let overview: String?
 let posterPath: String?
 let backdropPath: String?
 let poster: String?
 let backdrop: String?
 let voteAverage: Double?
 let tmdbId: Int?
 let doubanId: String?
 let imdbId: String?
 let season: Int?
 let episodes: Int?
 let source: String?

 enum CodingKeys: String, CodingKey {
  case id
  case title
  case name
  case originalTitle
  case year
  case releaseDate
  case type
  case mediaType
  case overview
  case posterPath
  case backdropPath
  case poster
  case backdrop
  case voteAverage
  case tmdbId
  case doubanId
  case imdbId
  case season
  case episodes
  case source
 }

 init(
  id: Int?,
  title: String?,
  name: String?,
  originalTitle: String?,
  year: String?,
  releaseDate: String?,
  type: String?,
  mediaType: String?,
  overview: String?,
  posterPath: String?,
  backdropPath: String?,
  poster: String?,
  backdrop: String?,
  voteAverage: Double?,
  tmdbId: Int?,
  doubanId: String?,
  imdbId: String?,
  season: Int?,
  episodes: Int?,
  source: String?
 ) {
  self.id = id
  self.title = title
  self.name = name
  self.originalTitle = originalTitle
  self.year = year
  self.releaseDate = releaseDate
  self.type = type
  self.mediaType = mediaType
  self.overview = overview
  self.posterPath = posterPath
  self.backdropPath = backdropPath
  self.poster = poster
  self.backdrop = backdrop
  self.voteAverage = voteAverage
  self.tmdbId = tmdbId
  self.doubanId = doubanId
  self.imdbId = imdbId
  self.season = season
  self.episodes = episodes
  self.source = source
 }

 init(from decoder: Decoder) throws {
  let container = try decoder.container(keyedBy: CodingKeys.self)
  id = try container.decodeLossyInt(forKey: .id)
  title = try container.decodeLossyString(forKey: .title)
  name = try container.decodeLossyString(forKey: .name)
  originalTitle = try container.decodeLossyString(forKey: .originalTitle)
  year = try container.decodeLossyString(forKey: .year)
  releaseDate = try container.decodeLossyString(forKey: .releaseDate)
  type = try container.decodeLossyString(forKey: .type)
  mediaType = try container.decodeLossyString(forKey: .mediaType)
  overview = try container.decodeLossyString(forKey: .overview)
  posterPath = try container.decodeLossyString(forKey: .posterPath)
  backdropPath = try container.decodeLossyString(forKey: .backdropPath)
  poster = try container.decodeLossyString(forKey: .poster)
  backdrop = try container.decodeLossyString(forKey: .backdrop)
  voteAverage = try container.decodeLossyDouble(forKey: .voteAverage)
  tmdbId = try container.decodeLossyInt(forKey: .tmdbId)
  doubanId = try container.decodeLossyString(forKey: .doubanId)
  imdbId = try container.decodeLossyString(forKey: .imdbId)
  season = try container.decodeLossyInt(forKey: .season)
  episodes = try container.decodeLossyInt(forKey: .episodes)
  source = try container.decodeLossyString(forKey: .source)
 }

 var stableID: String {
 if let tmdbId { return "tmdb-\(tmdbId)" }
 if let doubanId, !doubanId.isEmpty { return "douban-\(doubanId)" }
 if let imdbId, !imdbId.isEmpty { return "imdb-\(imdbId)" }
 if let id { return "id-\(id)" }
 return [displayTitle, year ?? "", mediaKind].joined(separator: "-")
 }

 var displayTitle: String {
 title ?? name ?? originalTitle ?? "未命名媒体"
 }

 var subtitleLine: String {
 [mediaKind, yearText].filter { !$0.isEmpty }.joined(separator: " · ")
 }

 var mediaKind: String {
 mediaType ?? type ?? "未知类型"
 }

 var yearText: String {
 if let year, !year.isEmpty { return year }
 if let releaseDate, releaseDate.count >= 4 { return String(releaseDate.prefix(4)) }
 return ""
 }

 var posterURLString: String? {
 poster ?? posterPath
 }

 var ratingText: String? {
 guard let voteAverage else { return nil }
 return String(format: "%.1f", voteAverage)
 }
}

struct MediaDetail: Decodable {
 let id: Int?
 let title: String?
 let name: String?
 let originalTitle: String?
 let year: String?
 let releaseDate: String?
 let type: String?
 let mediaType: String?
 let overview: String?
 let posterPath: String?
 let backdropPath: String?
 let poster: String?
 let backdrop: String?
 let voteAverage: Double?
 let tmdbId: Int?
 let doubanId: String?
 let imdbId: String?
 let season: Int?
 let episodes: Int?
 let source: String?
 let genres: [String]?
 let countries: [String]?
 let directors: [String]?
 let actors: [String]?

 enum CodingKeys: String, CodingKey {
  case id
  case title
  case name
  case originalTitle
  case year
  case releaseDate
  case type
  case mediaType
  case overview
  case posterPath
  case backdropPath
  case poster
  case backdrop
  case voteAverage
  case tmdbId
  case doubanId
  case imdbId
  case season
  case episodes
  case source
  case genres
  case countries
  case directors
  case actors
 }

 init(
  id: Int?,
  title: String?,
  name: String?,
  originalTitle: String?,
  year: String?,
  releaseDate: String?,
  type: String?,
  mediaType: String?,
  overview: String?,
  posterPath: String?,
  backdropPath: String?,
  poster: String?,
  backdrop: String?,
  voteAverage: Double?,
  tmdbId: Int?,
  doubanId: String?,
  imdbId: String?,
  season: Int?,
  episodes: Int?,
  source: String?,
  genres: [String]?,
  countries: [String]?,
  directors: [String]?,
  actors: [String]?
 ) {
  self.id = id
  self.title = title
  self.name = name
  self.originalTitle = originalTitle
  self.year = year
  self.releaseDate = releaseDate
  self.type = type
  self.mediaType = mediaType
  self.overview = overview
  self.posterPath = posterPath
  self.backdropPath = backdropPath
  self.poster = poster
  self.backdrop = backdrop
  self.voteAverage = voteAverage
  self.tmdbId = tmdbId
  self.doubanId = doubanId
  self.imdbId = imdbId
  self.season = season
  self.episodes = episodes
  self.source = source
  self.genres = genres
  self.countries = countries
  self.directors = directors
  self.actors = actors
 }

 init(from decoder: Decoder) throws {
  let container = try decoder.container(keyedBy: CodingKeys.self)
  id = try container.decodeLossyInt(forKey: .id)
  title = try container.decodeLossyString(forKey: .title)
  name = try container.decodeLossyString(forKey: .name)
  originalTitle = try container.decodeLossyString(forKey: .originalTitle)
  year = try container.decodeLossyString(forKey: .year)
  releaseDate = try container.decodeLossyString(forKey: .releaseDate)
  type = try container.decodeLossyString(forKey: .type)
  mediaType = try container.decodeLossyString(forKey: .mediaType)
  overview = try container.decodeLossyString(forKey: .overview)
  posterPath = try container.decodeLossyString(forKey: .posterPath)
  backdropPath = try container.decodeLossyString(forKey: .backdropPath)
  poster = try container.decodeLossyString(forKey: .poster)
  backdrop = try container.decodeLossyString(forKey: .backdrop)
  voteAverage = try container.decodeLossyDouble(forKey: .voteAverage)
  tmdbId = try container.decodeLossyInt(forKey: .tmdbId)
  doubanId = try container.decodeLossyString(forKey: .doubanId)
  imdbId = try container.decodeLossyString(forKey: .imdbId)
  season = try container.decodeLossyInt(forKey: .season)
  episodes = try container.decodeLossyInt(forKey: .episodes)
  source = try container.decodeLossyString(forKey: .source)
  genres = try container.decodeLossyStringArray(forKey: .genres)
  countries = try container.decodeLossyStringArray(forKey: .countries)
  directors = try container.decodeLossyStringArray(forKey: .directors)
  actors = try container.decodeLossyStringArray(forKey: .actors)
 }

 var displayTitle: String {
 title ?? name ?? originalTitle ?? "未命名媒体"
 }

 var mediaKind: String {
 mediaType ?? type ?? "未知类型"
 }

 var yearText: String {
 if let year, !year.isEmpty { return year }
 if let releaseDate, releaseDate.count >= 4 { return String(releaseDate.prefix(4)) }
 return ""
 }

 var posterURLString: String? {
 poster ?? posterPath
 }

 var backdropURLString: String? {
 backdrop ?? backdropPath
 }

 var ratingText: String? {
 guard let voteAverage else { return nil }
 return String(format: "%.1f", voteAverage)
 }
}
