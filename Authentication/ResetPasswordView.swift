//
//  ResetPasswordView.swift
//  acut
//
//  Created by Dani Fornons on 22/5/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var showAlert = false
    @State private var mAlert = ""

    @Environment(\.dismiss) private var dismiss
    @State private var textEmail: String = ""
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    var body: some View {
        NavigationStack {
            
                TextField("correu corporatiu ",text: $textEmail)
                .padding()
        
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
                        authenticationViewModel.resetPassword(email:textEmail){ success in
                            if success {
                                mAlert="S'ha enviat un correu a l'adreça indicada\nSi el correu es vàlid rebreu un missatge per fer el canvi de contrasenya\nSi no el rebeu contacteu amb informàtica de la SAP Lleida Nord"
                                 showAlert.toggle()
                                print("Reset successful")
                                
                            } else {
                                mAlert=authenticationViewModel.messageError ?? "Error enviant missatge"
                                print("Reset failed")
                                showAlert.toggle()
                            }
                        }
                    
                }) {
                        Text("Reset")
                    }
                }
            }
            .navigationTitle("Reset Contrasenya")
            .navigationBarTitleDisplayMode(.inline)
       Spacer()
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
            .alert(isPresented:
                    $showAlert) {
                Alert(title: Text("Reset de Contrasenya"),
                      message: Text(mAlert),
                      dismissButton: .default(Text("OK")){
                })
                
                
            }
    }
    }


#Preview {
    ResetPasswordView( authenticationViewModel: AuthenticationViewModel())
}
