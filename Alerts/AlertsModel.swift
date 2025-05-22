//
//  AlertsModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation
import FirebaseFirestore

struct AlertsModel: Decodable, Identifiable, Encodable, Hashable{
    @DocumentID var id: String?
    let codiSem : String
    let prioritat : String
    let uid: String
    let nom: String
    let adreça: [String]
    let comentari: String?
    let imatge: String?
    let codiDiagnostic: String?
    let nomDiagnostic: String?
    var horaInici: String?
    let horaEntrada: String?
    let horaSortida: String?
}
