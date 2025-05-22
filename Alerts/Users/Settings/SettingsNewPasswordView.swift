//
//  SettingsNewPassword.swift
//  acut
//
//  Created by Dani Fornons on 12/6/24.
//

import SwiftUI

struct SettingsNewPasswordView: View {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
   
    var body: some View {
        NavigationStack {
            SecureField("Contrasenya Actual", text: $currentPassword)
            SecureField("Contrasenya Nova", text: $newPassword)
            SecureField("Confirmació Contrasenya Nova", text: $confirmPassword)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Change"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel·lar")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        authenticationViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) { success in
                            if success {
                                alertMessage = "S'ha canviat la contrasenya correctament"
                                
                            } else {
                                alertMessage = authenticationViewModel.messageError ?? "Error changing password"
                            }
                            showAlert.toggle()
                        }
                    }) {
                        Text("Canviar")
                    }
                }
            }
            .navigationTitle("Canvi Contrasenya")
            .navigationBarTitleDisplayMode(.inline)
       Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .padding()
         }
}

#Preview {
    SettingsNewPasswordView()
}
