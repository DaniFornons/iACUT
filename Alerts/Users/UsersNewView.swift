    //
    //  UsersNewView.swift
    //  acut
    //
    //  Created by Dani Fornons on 24/5/24.
    //

    import SwiftUI

    struct UsersNewView: View {
        @State private var textEmail: String = ""
        @State private var textName: String = ""
        @State private var isAdmin: Bool = false
        @Environment(\.dismiss) private var dismiss
        @ObservedObject var authenticationViewModel = AuthenticationViewModel()
        @StateObject var usersViewModel: UsersViewModel = UsersViewModel()
        @State private var showAlert = false
        @State private var mError:String=""
        @State private var mTitle:String="Error"
       var body: some View {
            NavigationStack {
                Form{
                     TextField("Nom complert ", text: $textName)

                    TextField("Correu corporatiu ", text: $textEmail)
                        
                    Toggle("Administratiu", isOn: $isAdmin)
                        .toggleStyle(.switch)
                        
                }.toolbar{
                    ToolbarItem() {
                        Button(action: {
                            authenticationViewModel.createNewUser(email: textEmail, password: "Pirineu2024") { success in
                                if success {
                                    print("new user created in authentication")
                                    let newUser = UsersModel(uid: authenticationViewModel.user?.uid ?? "1234", name: textName, isAdmin: isAdmin)
                                    usersViewModel.createNewUser(user: newUser) { success in
                                        if success {
                                            print("new user created in collection")
                                            mTitle="Nou Usuari"
                                            mError="S'ha afegit l'usuari"
                                        }else{
                                            mError=usersViewModel.messageError ?? "1"
                                            mTitle="Error"
                                        }
                                    }
                                }else{
                                    mError = authenticationViewModel.messageError ?? "2"
                                    mTitle="Error"
                                }
                                showAlert.toggle()
                            }
                        }) {
                            Text("Guardar")
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text(mTitle),
                                  message: Text(mError),
                                  dismissButton: .default(Text("OK")))
                        
                    }
                    }
                    
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                //clearData()
                                dismiss()
                            }) {
                                Text("Cancel·lar")
                            }
                        }
                }
                .navigationTitle("Nou Usuari")
                .navigationBarTitleDisplayMode(.inline)
                
                
            }
                
        }
    }

    #Preview {
        UsersNewView(authenticationViewModel: AuthenticationViewModel(), usersViewModel: UsersViewModel())
    }
