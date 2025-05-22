//
//  acutApp.swift
//  acut
//
//  Created by Dani Fornons on 16/5/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct acutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var appState = AppState() // Add this line

    var body: some Scene {
        WindowGroup {
            if let _ = authenticationViewModel.user {
                HomeView(authenticationViewModel: authenticationViewModel)
                    .environmentObject(appState) // Inject here
            } else {
                AuthenticationView(authenticationViewModel: authenticationViewModel)
                    .environmentObject(appState)
            }
        }
    }
}
