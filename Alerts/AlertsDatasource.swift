//
//  AlertsDatasource.swift
//  acut
//
//  Created by Dani Fornons on 21/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AlertsModel: Decodable, Identifiable {
    @DocumentID var id: String?
    let codiSem : String
    let codiDiagnostic : String
    let horaInici : String
}

final class AlertsDatasource {
    private let database = Firestore.firestore()
    private let collection = "alerts"
    
    func getAllAlerts(completionBlock: @escaping(Result<[AlertsModel], Error>) -> Void){
        database.collection(collection)
            .addSnapshotListener { query, error in
                if let error = error {
                    print ("Error getting all links \(error.localizedDescription)")
                    completionBlock(.failure(error))
                    return
                }
                guard let documents = query?.documents.compactMap({ $0 }) else {
                    completionBlock(.success([]))
                    return
                }
                let alerts = documents.map {try? $0.data(as: AlertsModel.self)}
                    .compactMap { $0}
                completionBlock(.success(alerts))
            }
    }
}
