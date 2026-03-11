import Foundation

extension KeyedDecodingContainer {
  func decodeLossyString(forKey key: Key) throws -> String? {
    if let value = try decodeIfPresent(String.self, forKey: key) {
      return value
    }
    if let value = try decodeIfPresent(Int.self, forKey: key) {
      return String(value)
    }
    if let value = try decodeIfPresent(Double.self, forKey: key) {
      return String(value)
    }
    if let value = try decodeIfPresent(Bool.self, forKey: key) {
      return value ? "true" : "false"
    }
    return nil
  }

  func decodeLossyInt(forKey key: Key) throws -> Int? {
    if let value = try decodeIfPresent(Int.self, forKey: key) {
      return value
    }
    if let value = try decodeIfPresent(Double.self, forKey: key) {
      return Int(value)
    }
    if let value = try decodeIfPresent(String.self, forKey: key) {
      let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
      if let intValue = Int(trimmed) {
        return intValue
      }
      if let doubleValue = Double(trimmed) {
        return Int(doubleValue)
      }
    }
    return nil
  }

  func decodeLossyDouble(forKey key: Key) throws -> Double? {
    if let value = try decodeIfPresent(Double.self, forKey: key) {
      return value
    }
    if let value = try decodeIfPresent(Int.self, forKey: key) {
      return Double(value)
    }
    if let value = try decodeIfPresent(String.self, forKey: key) {
      return Double(value.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    return nil
  }

  func decodeLossyBool(forKey key: Key) throws -> Bool? {
    if let value = try decodeIfPresent(Bool.self, forKey: key) {
      return value
    }
    if let value = try decodeIfPresent(Int.self, forKey: key) {
      return value != 0
    }
    if let value = try decodeIfPresent(String.self, forKey: key) {
      switch value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
      case "true", "1", "yes", "y", "on":
        return true
      case "false", "0", "no", "n", "off":
        return false
      default:
        return nil
      }
    }
    return nil
  }

  func decodeLossyStringArray(forKey key: Key) throws -> [String]? {
    if let values = try decodeIfPresent([String].self, forKey: key) {
      return values
    }
    if let value = try decodeLossyString(forKey: key) {
      let separators = CharacterSet(charactersIn: ",/|，、")
      let parts = value
        .components(separatedBy: separators)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
      return parts.isEmpty ? [value] : parts
    }
    return nil
  }
}
