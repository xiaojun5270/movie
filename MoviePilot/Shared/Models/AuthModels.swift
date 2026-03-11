import Foundation

struct AuthToken: Codable {
 let accessToken: String
 let tokenType: String
 let superUser: Bool
 let userId: Int
 let userName: String
 let avatar: String?
 let level: Int

  enum CodingKeys: String, CodingKey {
    case accessToken
    case tokenType
    case superUser
    case userId
    case userName
    case avatar
    case level
  }

  init(accessToken: String, tokenType: String, superUser: Bool, userId: Int, userName: String, avatar: String?, level: Int) {
    self.accessToken = accessToken
    self.tokenType = tokenType
    self.superUser = superUser
    self.userId = userId
    self.userName = userName
    self.avatar = avatar
    self.level = level
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    accessToken = try container.decode(String.self, forKey: .accessToken)
    tokenType = try container.decodeLossyString(forKey: .tokenType) ?? "bearer"
    superUser = try container.decodeLossyBool(forKey: .superUser) ?? false
    userId = try container.decodeLossyInt(forKey: .userId) ?? 0
    userName = try container.decodeLossyString(forKey: .userName) ?? ""
    avatar = try container.decodeLossyString(forKey: .avatar)
    level = try container.decodeLossyInt(forKey: .level) ?? 0
  }
}

struct CurrentUser: Codable, Identifiable {
 let id: Int
 let name: String
 let email: String?
 let isActive: Bool?
 let isSuperuser: Bool
 let avatar: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case isActive
    case isSuperuser
    case avatar
  }

  init(id: Int, name: String, email: String?, isActive: Bool?, isSuperuser: Bool, avatar: String?) {
    self.id = id
    self.name = name
    self.email = email
    self.isActive = isActive
    self.isSuperuser = isSuperuser
    self.avatar = avatar
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeLossyInt(forKey: .id) ?? 0
    name = try container.decodeLossyString(forKey: .name) ?? ""
    email = try container.decodeLossyString(forKey: .email)
    isActive = try container.decodeLossyBool(forKey: .isActive)
    isSuperuser = try container.decodeLossyBool(forKey: .isSuperuser) ?? false
    avatar = try container.decodeLossyString(forKey: .avatar)
  }
}
