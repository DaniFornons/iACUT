//
//  AuthenticationFirebaseDatasource.swift
//  acut
//
//  Created by Dani Fornons on 16/5/24.
//

import Foundation
import FirebaseAuth



final class AuthenticationFirebaseDatasource{
    func getCurrentUser()-> AuthUserModel?{
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return .init(email: email, uid: uid)
    }
    
    func createNewUser(email: String, password: String, completionBlock: @escaping (Result<AuthUserModel,Error>)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print ("Error creating new user \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            let email = authDataResult?.user.email ?? "No email"
            let uid = authDataResult?.user.uid ?? "No uid"
             print ("New user created with info \(email)")
            completionBlock(.success(.init(email: email, uid: uid)))
        }
    }
    
    func login(email: String, password: String, completionBlock: @escaping (Result<AuthUserModel,Error>)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print ("Error login user \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            let email = authDataResult?.user.email ?? "No email"
            let uid = authDataResult?.user.uid ?? "No uid"
            print ("User login with info \(email)")
            completionBlock(.success(.init(email: email, uid: uid)))
        }
    }
    
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    
    
    
    func resetPassword(email:String, completionBlock: @escaping (Result<Void,Error>)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print ("Error sending message: \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            print ("Message send to \(email)")
            completionBlock(.success(()))
    }
}
    func reauthenticateUser(currentPassword: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
            guard let user = Auth.auth().currentUser, let email = user.email else {
                completionBlock(.failure(NSError(domain: "No current user", code: 0, userInfo: nil)))
                return
            }

            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    completionBlock(.failure(error))
                } else {
                    completionBlock(.success(()))
                }
            }
        }

        func changePassword(newPassword: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
            guard let user = Auth.auth().currentUser else {
                completionBlock(.failure(NSError(domain: "No current user", code: 0, userInfo: nil)))
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completionBlock(.failure(error))
                } else {
                    completionBlock(.success(()))
                }
            }
        }
}
