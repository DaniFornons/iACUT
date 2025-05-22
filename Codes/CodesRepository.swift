//
//  CodesRepository.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation

final class CodesRepository{
    private let codesDataSource: CollectionFirebaseDatasource
    private let collection : String = "codes"
    init(codesDataSource: CollectionFirebaseDatasource = CollectionFirebaseDatasource()){
        self.codesDataSource = codesDataSource
    }
    func getAllCodes(completionBlock:@escaping(Result<[CodesModel], Error>) -> Void) {
        codesDataSource.getAllData(toCollection: collection, completionBlock: completionBlock)
    }
}
