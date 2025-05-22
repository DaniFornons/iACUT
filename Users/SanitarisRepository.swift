//
//  SanitarisRepository.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation
final class SanitarisRepository{
    private let sanitarisDataSource: CollectionFirebaseDatasource
    private let collection : String = "sanitaris"
    init(sanitarisDataSource: CollectionFirebaseDatasource = CollectionFirebaseDatasource()){
        self.sanitarisDataSource = sanitarisDataSource
    }
    func getAllSanitaris(completionBlock:@escaping(Result<[UsersModel], Error>) -> Void) {
        sanitarisDataSource.getAllData(toCollection: collection, completionBlock: completionBlock)
    }
}
