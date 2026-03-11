import Foundation
import Security

class KeychainStore {
 private let service: String

 init(service: String = "com.junge.moviepilot") {
 self.service = service
 }

 func save(_ value: String, for key: String) {
 let data = Data(value.utf8)
 deleteValue(for: key)

 let query: [CFString: Any] = [
 kSecClass: kSecClassGenericPassword,
 kSecAttrService: service,
 kSecAttrAccount: key,
 kSecValueData: data
 ]

 SecItemAdd(query as CFDictionary, nil)
 }

 func readString(for key: String) -> String? {
 let query: [CFString: Any] = [
 kSecClass: kSecClassGenericPassword,
 kSecAttrService: service,
 kSecAttrAccount: key,
 kSecReturnData: true,
 kSecMatchLimit: kSecMatchLimitOne
 ]

 var item: CFTypeRef?
 let status = SecItemCopyMatching(query as CFDictionary, &item)
 guard status == errSecSuccess,
 let data = item as? Data,
 let string = String(data: data, encoding: .utf8) else {
 return nil
 }
 return string
 }

 func deleteValue(for key: String) {
 let query: [CFString: Any] = [
 kSecClass: kSecClassGenericPassword,
 kSecAttrService: service,
 kSecAttrAccount: key
 ]
 SecItemDelete(query as CFDictionary)
 }
}
