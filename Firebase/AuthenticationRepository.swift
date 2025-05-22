//
//  AuthenticationRepository.swift
//  acut
//
//  Created by Dani Fornons on 16/5/24.
//

import Foundation

final class AuthenticationRepository{
    private let authenticationFirebaseDatasource : AuthenticationFirebaseDatasource
    
    init(authenticationFirebaseDatasource : AuthenticationFirebaseDatasource = AuthenticationFirebaseDatasource()) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
    }
    
    func getCurrentUser()-> AuthUserModel?{
        authenticationFirebaseDatasource.getCurrentUser()
    }
    
    func createNewUser(email:String,password:String, completionBlock: @escaping (Result<AuthUserModel, Error>)->Void){
        authenticationFirebaseDatasource.createNewUser(email: email, password: password, completionBlock: completionBlock)
    }
    func login(email:String,password:String, completionBlock: @escaping (Result<AuthUserModel, Error>)->Void){
        authenticationFirebaseDatasource.login(email: email, password: password, completionBlock: completionBlock)
    }
    
    func logout() throws {
        try authenticationFirebaseDatasource.logout()
    }
    
    func resetPassword(email:String, completionBlock: @escaping (Result<Void, Error>)->Void) {
         authenticationFirebaseDatasource.resetPassword(email: email, completionBlock: completionBlock)
    }
    
    final class AuthenticationRepository {
        private let authenticationFirebaseDatasource: AuthenticationFirebaseDatasource
        
        init(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource = AuthenticationFirebaseDatasource()) {
            self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
        }
    }
    func reauthenticateUser(currentPassword: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
            authenticationFirebaseDatasource.reauthenticateUser(currentPassword: currentPassword, completionBlock: completionBlock)
        }

        func changePassword(newPassword: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
            authenticationFirebaseDatasource.changePassword(newPassword: newPassword, completionBlock: completionBlock)
        }
}
