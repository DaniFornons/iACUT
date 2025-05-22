//
//  CodeModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation
import FirebaseFirestore

struct CodesModel: Decodable, Identifiable, Encodable{
    @DocumentID var id: String?
    let code : String
    let text: String
}
