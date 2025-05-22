//
//  UsersViewModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation

final class UsersViewModel: ObservableObject{
    @Published var users: [UserAuthModel] = []
    @Published var messageError : String?
    
    private var usersRepository = CollectionRepository<UserAuthModel>(collection: "users")
    
    init(usersRepository : CollectionRepository<UserAuthModel> = CollectionRepository(collection: "users")){
        self.usersRepository = usersRepository
    }
    
    func getAllUsers(){
        usersRepository.getAllData{ [weak self] result in
            switch result {
            case .success(let usersModels):
                self?.users = usersModels
                
            case .failure(let error):
                self?.messageError = error.localizedDescription
                 
            }
        }
    }
    
    func getUsersByField(field: String, value: Any) {
            usersRepository.getDataByField(field: field, value: value) { [weak self] result in
                switch result {
                case .success(let usersModels):
                    self?.users = usersModels
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                }
            }
        }
    
}


