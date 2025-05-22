//
//  ProfileView.swift
//  acut
//
//  Created by Dani Fornons on 21/5/24.
//

import SwiftUI


struct SettingsView: View {
    @ObservedObject var authenticationViewModel : AuthenticationViewModel
    
    var body: some View {
                Button("Sortir", systemImage: "rectangle.portrait.and.arrow.right", action: authenticationViewModel.logout)
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .padding()
    }
}

#Preview {
    SettingsView(authenticationViewModel: AuthenticationViewModel())
}
