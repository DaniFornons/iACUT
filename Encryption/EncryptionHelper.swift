//
//  EncryptionHelper.swift
//  acut
//
//  Created by Dani Fornons on 16/4/25.
//

import Foundation
import CryptoKit

struct EncryptionHelper {
    static var key: SymmetricKey {
        (try? KeychainHelper.generateAndSaveKeyIfNeeded()) ?? SymmetricKey(size: .bits256)
    }

    static func encrypt(_ text: String) throws -> String {
        let data = Data(text.utf8)
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!.base64EncodedString()
    }

    static func decrypt(_ base64String: String) throws -> String {
        guard let combinedData = Data(base64Encoded: base64String) else {
            throw NSError(domain: "InvalidBase64", code: -1, userInfo: nil)
        }
        let sealedBox = try AES.GCM.SealedBox(combined: combinedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(decoding: decryptedData, as: UTF8.self)
    }
}

