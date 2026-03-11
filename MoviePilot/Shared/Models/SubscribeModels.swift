import Foundation

struct SubscribeItem: Codable, Identifiable {
 let id: Int
 let name: String?
 let year: String?
 let type: String?
 let season: Int?
 let poster: String?
 let vote: Double?
 let totalEpisode: Int?
 let lackEpisode: Int?
 let state: String?
 let username: String?
 let lastUpdate: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case year
    case type
    case season
    case poster
    case vote
    case totalEpisode
    case lackEpisode
    case state
    case username
    case lastUpdate
  }

  init(
    id: Int,
    name: String?,
    year: String?,
    type: String?,
    season: Int?,
    poster: String?,
    vote: Double?,
    totalEpisode: Int?,
    lackEpisode: Int?,
    state: String?,
    username: String?,
    lastUpdate: String?
  ) {
    self.id = id
    self.name = name
    self.year = year
    self.type = type
    self.season = season
    self.poster = poster
    self.vote = vote
    self.totalEpisode = totalEpisode
    self.lackEpisode = lackEpisode
    self.state = state
    self.username = username
    self.lastUpdate = lastUpdate
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeLossyInt(forKey: .id) ?? 0
    name = try container.decodeLossyString(forKey: .name)
    year = try container.decodeLossyString(forKey: .year)
    type = try container.decodeLossyString(forKey: .type)
    season = try container.decodeLossyInt(forKey: .season)
    poster = try container.decodeLossyString(forKey: .poster)
    vote = try container.decodeLossyDouble(forKey: .vote)
    totalEpisode = try container.decodeLossyInt(forKey: .totalEpisode)
    lackEpisode = try container.decodeLossyInt(forKey: .lackEpisode)
    state = try container.decodeLossyString(forKey: .state)
    username = try container.decodeLossyString(forKey: .username)
    lastUpdate = try container.decodeLossyString(forKey: .lastUpdate)
  }
}
