//
//  UsersViewModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation

final class UsersViewModel: ObservableObject{
    @Published var user: UsersModel?
    @Published var users: [UsersModel] = []
    @Published var messageError : String?
    
    private var usersRepository = CollectionRepository<UsersModel>(collection: "users")
    
    init(usersRepository : CollectionRepository<UsersModel> = CollectionRepository(collection: "users")){
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
    func createNewUser(user: UsersModel,completion: @escaping (Bool) -> Void) {
        usersRepository.createNewData(data: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newUser):
                    self?.users.append(newUser)
                    completion(true)
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    completion (false)
                }
            }
        }
    }
    
    func getUserInfo(uid:String,completion: @escaping (Bool) -> Void){
        usersRepository.getDataByField(field: "uid", value: uid){[weak self] result in
            switch result {
            
            case .success(let usersModels):
                self?.user = usersModels.first
                completion(true)
                    
            case .failure(let error):
                self?.messageError = error.localizedDescription
                 completion(false)
        }
            
        }
    }
}


