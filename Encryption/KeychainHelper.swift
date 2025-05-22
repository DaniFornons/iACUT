//
//  KeychainHelper.swift
//  acut
//
//  Created by Dani Fornons on 16/4/25.
//

import Foundation
import CryptoKit
import Security

struct KeychainHelper {
    static let keyTag = "com.iacut.encryptionkey"

    static func saveKey(_ key: SymmetricKey) throws {
        let keyData = key.withUnsafeBytes { Data($0) }

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainSaveError", code: Int(status), userInfo: nil)
        }
    }

    static func loadKey() throws -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let keyData = result as? Data else {
            throw NSError(domain: "KeychainLoadError", code: Int(status), userInfo: nil)
        }

        return SymmetricKey(data: keyData)
    }

    static func generateAndSaveKeyIfNeeded() throws -> SymmetricKey {
        do {
            return try loadKey()
        } catch {
            let newKey = SymmetricKey(size: .bits256)
            try saveKey(newKey)
            return newKey
        }
    }
}
