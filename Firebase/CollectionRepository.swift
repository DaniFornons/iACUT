//
//  CollectionRepository.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation

final class CollectionRepository<T: Decodable & Codable> {
    private let dataSource: CollectionFirebaseDatasource
    private let collection: String

    init(collection: String, dataSource: CollectionFirebaseDatasource = CollectionFirebaseDatasource()) {
        self.dataSource = dataSource
        self.collection = collection
    }

    func getAllData(completionBlock: @escaping (Result<[T], Error>) -> Void) {
        dataSource.getAllData(toCollection: collection, completionBlock: completionBlock)
    }

    func createNewData(data: T, completionBlock: @escaping (Result<T, Error>) -> Void) {
        dataSource.createNewData(toCollection: collection, data: data, completionBlock: completionBlock)
    }

    func getDataByField(field: String, value: Any, completionBlock: @escaping (Result<[T], Error>) -> Void) {
        dataSource.getDataByField(fromCollection: collection, field: field, value: value, completionBlock: completionBlock)
    }

    func deleteDataById(documentId: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        dataSource.deleteDataById(fromCollection: collection, documentId: documentId, completionBlock: completionBlock)
    }
    
    func updateDataById(documentId: String, data: T, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        dataSource.updateDataById(inCollection: collection, documentId: documentId, data: data, completionBlock: completionBlock)
    }
}
