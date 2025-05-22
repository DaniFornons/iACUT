//
//  AdminsRepository.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation
final class UsersRepository{
    private let usersDataSource: CollectionFirebaseDatasource
    init(usersDataSource: CollectionFirebaseDatasource = CollectionFirebaseDatasource()){
        self.usersDataSource = usersDataSource
    }
    func getAllUsers(toCollection collection : String,completionBlock:@escaping(Result<[UsersModel], Error>) -> Void) {
        usersDataSource.getAllData(toCollection: collection, completionBlock: completionBlock)
    }
}
