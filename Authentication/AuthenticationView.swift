//
//  ContentView.swift
//  acut
//
//  Created by Dani Fornons on 16/5/24.
//

import SwiftUI

struct AuthenticationView: View {

    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var usersViewModel = UsersViewModel()
    @EnvironmentObject var appState: AppState
    
    @State private var textEmail: String = ""
    @State private var textPassword: String = ""
    @State private var resetPassword: Bool = false
  
    @AppStorage("admin") private var isAdmin : Bool = false
    @AppStorage("uid") private var uid : String = ""

    
    @State var showAlert: Bool = false
    
    var body: some View {
      
        VStack {
            
            Image("acutix")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
    
            Image("acutix")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
    
            Text("GAPiC Alt Pirineu")
                .bold()
                .font(.largeTitle)
            
            Group{
                Text("Benvingut").font(.largeTitle)
                    .foregroundStyle(.blue)
                    .bold()
                TextField("Correu corporatiu ",text: $textEmail)
                SecureField("Contrasenya ",text: $textPassword)
                
                HStack {
                    Spacer()
                    Button("Has oblidat la contrasenya?")
                        {
                             resetPassword.toggle()
                    }
                }
                Button(" Entrar                "){
                    authenticationViewModel.login(email: textEmail, password: textPassword) { success in
                        if success {
                            print("Login succesfull")
                            usersViewModel.getUserInfo(uid: authenticationViewModel.user?.uid ?? ""){
                                success in
                                if success {
                                    print("User info succesfull")
                                    isAdmin = usersViewModel.user?.isAdmin ?? false
                                    uid = usersViewModel.user?.uid ?? ""
                                    appState.selectedIndex = 0
                                }
                                else {
                                        print("User info failed")
                                }
                            }
                        }
                        else {
                            print("Login failed")
                            showAlert.toggle()
                        }
                    }
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding()
                
                
                Spacer()
            }
            .textFieldStyle(.roundedBorder)
        }
        .padding()
        .sheet(isPresented: $resetPassword) {
            ResetPasswordView(authenticationViewModel : authenticationViewModel)
        }
        .alert(isPresented:
                $showAlert) {
            Alert(title: Text("Error al Entrar"),
                  message: Text(authenticationViewModel.messageError ?? "Error"),
                  dismissButton: .default(Text("OK")))
        }
    }
}


#Preview {
    AuthenticationView(authenticationViewModel : AuthenticationViewModel()).environmentObject(AppState())
}
