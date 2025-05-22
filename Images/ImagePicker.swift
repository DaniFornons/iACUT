//
//  ImagePicker.swift
//  acut
//
//  Created by Dani Fornons on 3/6/24.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage : UIImage?
    @Binding var showPicker: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
       // <#code#>
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}
class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var parent
    : ImagePicker
    
    init (_ picker: ImagePicker){
        self.parent = picker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //code when image selected
        print ("image selected")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        parent.showPicker = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Run code when cancelled teh picker UI
        print("image cancelled")
        parent.showPicker = false
    }
    
}
