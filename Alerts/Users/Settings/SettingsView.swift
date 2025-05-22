//
//  SettingsView.swift
//  acut
//
//  Created by Dani Fornons on 12/6/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var showAlert = false
    @State private var showPassword = false
    @EnvironmentObject var appState: AppState
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            Button("Canviar Contrasenya", systemImage: "lock.fill") {
                showPassword.toggle()
            }.padding()
                .tint(.blue)
            Button("          Sortir               ", systemImage: "rectangle.portrait.and.arrow.right") {
                showAlert.toggle()
            }.tint(.red)
            .navigationTitle("Opcions")
            Spacer()
        }
        .buttonStyle(.bordered)
        
        .sheet(isPresented: $showPassword) {
            SettingsNewPasswordView()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Sortir"),
                message: Text("Esteu segurs que voleu sortir?"),
                primaryButton: .destructive(Text("Sortir")) {
                    authenticationViewModel.logout()
                    print("surt")
                },
                secondaryButton: .cancel {}
            )
        }
    }
}

#Preview {
    SettingsView( authenticationViewModel: AuthenticationViewModel())
}
