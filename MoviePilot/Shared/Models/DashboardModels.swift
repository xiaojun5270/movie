import Foundation

struct DashboardStatistic: Codable {
 let movieCount: Int?
 let tvCount: Int?
 let episodeCount: Int?
 let userCount: Int?
}

struct StorageInfo: Codable {
 let totalStorage: Double?
 let usedStorage: Double?

 var usageRatio: Double {
 guard let totalStorage, totalStorage > 0, let usedStorage else { return 0 }
 return usedStorage / totalStorage
 }
}

struct DownloaderInfo: Codable {
 let downloadSpeed: Double?
 let uploadSpeed: Double?
 let downloadSize: Double?
 let uploadSize: Double?
 let freeSpace: Double?
}
