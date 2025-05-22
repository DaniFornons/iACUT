//
//  CollectionFirebaseDatasource.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CollectionFirebaseDatasource {
    private var database = Firestore.firestore()

    func getAllData<T: Decodable>(toCollection collection: String, completionBlock: @escaping (Result<[T], Error>) -> Void) {
        database.collection(collection)
            .addSnapshotListener { query, error in
                if let error = error {
                    print("Error getting all data \(error.localizedDescription)")
                    completionBlock(.failure(error))
                    return
                }
                guard let documents = query?.documents.compactMap({ $0 }) else {
                    completionBlock(.success([]))
                    return
                }
                let data = documents.map { try? $0.data(as: T.self) }
                    .compactMap { $0 }
                completionBlock(.success(data))
            }
    }

    func createNewData<T: Codable>(toCollection collection: String, data: T, completionBlock: @escaping (Result<T, Error>) -> Void) {
        do {
            try _ = database.collection(collection).addDocument(from: data)
            completionBlock(.success(data))
        } catch {
            completionBlock(.failure(error))
        }
    }

    func getDataByField<T: Decodable>(fromCollection collection: String, field: String, value: Any, completionBlock: @escaping (Result<[T], Error>) -> Void) {
            database.collection(collection).whereField(field, isEqualTo: value)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("Error getting data by field \(error.localizedDescription)")
                        completionBlock(.failure(error))
                        return
                    }
                    guard let documents = querySnapshot?.documents.compactMap({ $0 }) else {
                        completionBlock(.success([]))
                        return
                    }
                    let data = documents.map { try? $0.data(as: T.self) }
                        .compactMap { $0 }
                    completionBlock(.success(data))
                }
        }

    func deleteDataById(fromCollection collection: String, documentId: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        database.collection(collection).document(documentId).delete { error in
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(()))
            }
        }
    }
    
    func updateDataById<T: Codable>(inCollection collection: String, documentId: String, data: T, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        do {
            try database.collection(collection).document(documentId).setData(from: data) { error in
                if let error = error {
                    completionBlock(.failure(error))
                } else {
                    completionBlock(.success(()))
                }
            }
        } catch {
            completionBlock(.failure(error))
        }
    }
    
}
