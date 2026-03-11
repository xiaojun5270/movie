import Foundation

struct DownloadItem: Codable, Identifiable {
 let downloader: String?
 let hash: String?
 let title: String?
 let name: String?
 let year: String?
 let seasonEpisode: String?
 let size: Double?
 let progress: Double?
 let state: String?
 let upspeed: String?
 let dlspeed: String?
 let leftTime: String?

  enum CodingKeys: String, CodingKey {
    case downloader
    case hash
    case title
    case name
    case year
    case seasonEpisode
    case size
    case progress
    case state
    case upspeed
    case dlspeed
    case leftTime
  }

  init(
    downloader: String?,
    hash: String?,
    title: String?,
    name: String?,
    year: String?,
    seasonEpisode: String?,
    size: Double?,
    progress: Double?,
    state: String?,
    upspeed: String?,
    dlspeed: String?,
    leftTime: String?
  ) {
    self.downloader = downloader
    self.hash = hash
    self.title = title
    self.name = name
    self.year = year
    self.seasonEpisode = seasonEpisode
    self.size = size
    self.progress = progress
    self.state = state
    self.upspeed = upspeed
    self.dlspeed = dlspeed
    self.leftTime = leftTime
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    downloader = try container.decodeLossyString(forKey: .downloader)
    hash = try container.decodeLossyString(forKey: .hash)
    title = try container.decodeLossyString(forKey: .title)
    name = try container.decodeLossyString(forKey: .name)
    year = try container.decodeLossyString(forKey: .year)
    seasonEpisode = try container.decodeLossyString(forKey: .seasonEpisode)
    size = try container.decodeLossyDouble(forKey: .size)
    progress = try container.decodeLossyDouble(forKey: .progress)
    state = try container.decodeLossyString(forKey: .state)
    upspeed = try container.decodeLossyString(forKey: .upspeed)
    dlspeed = try container.decodeLossyString(forKey: .dlspeed)
    leftTime = try container.decodeLossyString(forKey: .leftTime)
  }

 var id: String {
 hash ?? "\(downloader ?? "unknown")-\(title ?? name ?? "item")"
 }
}
