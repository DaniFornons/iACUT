//
//  HomeView.swift
//  acut
//
//  Created by Dani Fornons on 17/5/24.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State private var showAlert = false
    @EnvironmentObject var appState: AppState
    @AppStorage("admin") private var isAdmin: Bool = false
    @AppStorage("uid") private var uid: String = ""
    
    var body: some View {
        TabView(selection: $appState.selectedIndex) {
            if isAdmin {
                AlertsAdminView()
                    .tabItem {
                        Label("Alertes", systemImage: "rectangle.stack")
                    }
                    .tag(0)

                UsersView()
                    .tabItem {
                        Label("Usuaris", systemImage: "person.3.sequence.fill")
                    }
                    .tag(1)
            } else {
                AlertsSanitariView(uid: uid)
                    .tabItem {
                        Label("Alertes", systemImage: "rectangle.stack")
                    }
                    .tag(0)
            }

            CodesView()
                .tabItem {
                    Label("Codis", systemImage: "stethoscope")
                }
                .tag(3)
            SettingsView(authenticationViewModel: authenticationViewModel)
                .tabItem {
                    Label("Opcions", systemImage: "gear")
                }
                .tag(4)
            
        }
    }
}

#Preview {
    HomeView(authenticationViewModel: AuthenticationViewModel())
        .environmentObject(AppState()) // Add this line
}
    
