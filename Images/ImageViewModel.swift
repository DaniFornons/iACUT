//
//  AlertsViewModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation
import UIKit
import FirebaseStorage

final class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    func uploadPhoto(image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = image else {
            completion(.failure(NSError(domain: "UploadPhoto", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image is nil"])))
            return
        }
        
        let storageRef = Storage.storage().reference()
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "UploadPhoto", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image data conversion failed"])))
            return
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else if metadata != nil {
                completion(.success(path))
            } else {
                completion(.failure(NSError(domain: "UploadPhoto", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }
    }

    func retrievePhoto(path: String) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)
        
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error retrieving image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }

    func deletePhoto(path: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)
        
        fileRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
