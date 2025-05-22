//
//  AuthenticationViewModel.swift
//  acut
//
//  Created by Dani Fornons on 16/5/24.
//

import Foundation

final class AuthenticationViewModel: ObservableObject {
    @Published var user: AuthUserModel?
    @Published var messageError: String?
    
    private let authenticationRepository: AuthenticationRepository
    
    
    init(authenticationRepository: AuthenticationRepository = AuthenticationRepository()) {
        self.authenticationRepository = authenticationRepository
        getCurrentUser()
        
    }
    func getCurrentUser(){
        self.user = authenticationRepository.getCurrentUser()
    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
            authenticationRepository.createNewUser(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.user = user
                    completion(true)
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    completion(false)
                }
            }
        }
    func login(email:String, password: String, completion: @escaping (Bool) -> Void) {
        authenticationRepository.login(email: email,
                                               password: password ){[weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                
                completion(true)
                
            case .failure(let error):
                self?.messageError = error.localizedDescription
                completion(false)
            }
        }
    }
    
    func logout(){
        do{
            try authenticationRepository.logout()
            self.user = nil
            self.messageError=nil
            print ("logout")
        }catch{
            print ("Error logout")
        }
    }
    
    func resetPassword(email:String, completion: @escaping (Bool) -> Void) {
        
            authenticationRepository.resetPassword(email:email){[weak self] result in
                switch result {
                case .success():
                    completion(true)
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    completion(false)
                }
            }
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {
            authenticationRepository.reauthenticateUser(currentPassword: currentPassword) { [weak self] result in
                switch result {
                case .success():
                    self?.authenticationRepository.changePassword(newPassword: newPassword) { result in
                        switch result {
                        case .success():
                            completion(true)
                        case .failure(let error):
                            self?.messageError = error.localizedDescription
                            completion(false)
                        }
                    }
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    completion(false)
                }
            }
        }
}
