//
//  UsersModels.swift
//  acut
//
//  Created by Dani Fornons on 24/5/24.
//

import Foundation
import FirebaseFirestore

struct UsersModel: Decodable, Identifiable, Encodable{
    @DocumentID var id: String?
    let uid: String
    let name: String
    let isAdmin: Bool
}
