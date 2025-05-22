//
//  AlertsNewView.swift
//  acut
//
//  Created by Dani Fornons on 3/6/24.
//

import SwiftUI

struct AlertsNewView: View {
    @StateObject var usersViewModel: UsersViewModel = UsersViewModel()
    @StateObject var alertsViewModel: AlertsViewModel = AlertsViewModel()
    @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var comentari: String = ""
    
    @State private var codiSem: String = ""
    @State private var prioritat: String = ""
    @State private var uid: String = ""
    @State private var nom: String = ""
    
    @State private var showMessage: String = ""
    @State private var poblacio: String = ""
    @State private var carrer: String = ""
    @State private var numero: String = ""
    @State private var imatge: String = ""
    
    @State var showPicher = false
    @State var selectedImage: UIImage?
    
    @State private var showAlert: Bool = false
    @State private var mMessage: String = ""
    @State private var mTitle: String = ""
    @State private var isLoading: Bool = false // State for loading
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section("SEM") {
                        TextField("Codi Sem", text: $codiSem)
                                               Picker("Prioritat", selection: $prioritat) {
                                                   Text("P0").tag("P0")
                                                   Text("P1").tag("P1")
                                                   Text("P2").tag("P2")
                                                   Text("P3").tag("P3")
                                                   Text("P4").tag("P4")
                                               }
                                               .pickerStyle(SegmentedPickerStyle())
                                           
                    }
                    Section("Professional") {
                        Picker("Nom", selection: $uid) {
                            Text("").tag(String?.none)
                            ForEach(usersViewModel.users.filter { !$0.isAdmin }.sorted(by: { $0.name < $1.name })) { user in
                                Text(user.name).tag(user.uid)
                            }
                        }
                        .onChange(of: uid) { _ in
                            if let selectedUser = usersViewModel.users.first(where: { $0.uid == uid }) {
                                nom = selectedUser.name
                            } else {
                                nom = ""
                            }
                        }
                    }
                    Section("Adreça") {
                        TextField("Població", text: $poblacio)
                        TextField("Carrer", text: $carrer)
                        TextField("Número", text: $numero)
                    }
                    Section("comentari") {
                        TextEditor(text: $comentari)
                    }
                    Section("Imatge") {
                        VStack {
                            HStack {
                                Button {
                                    showPicher.toggle()
                                    print("select image")
                                } label: {
                                    Text("Selecciona Imatge")
                                }
                                Spacer()
                                Button {
                                    selectedImage = nil
                                    print("delete image")
                                } label: {
                                    Text("Borrar Imatge")
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                            if selectedImage != nil {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                            }
                        }.sheet(isPresented: $showPicher, onDismiss: nil) {
                            ImagePicker(selectedImage: $selectedImage, showPicker: $showPicher)
                        }
                    }
                    .onAppear {
                        usersViewModel.getAllUsers()
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(mTitle),
                              message: Text(mMessage),
                              dismissButton: .default(Text("OK")))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            //clearData()
                            dismiss()
                        }) {
                            Text("Cancel·lar")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if poblacio.isEmpty || codiSem.isEmpty || uid.isEmpty {
                                mTitle = "Error"
                                mMessage = "Codi SEM i Professional\nPoblacio\nsón obligatoris"
                                showAlert.toggle()
                            } else {
                                isLoading = true
                                if selectedImage != nil {
                                    saveImage()
                                } else {
                                    saveAlert()
                                }
                            }
                        }) {
                            Text("Guardar")
                        }
                    }
                }
                .navigationTitle("Nova Alerta")
                .navigationBarTitleDisplayMode(.inline)
         
                
                if isLoading {
                    ProgressView("Guardant...").progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                }
            }
        }
    }
    
    func clearData() {
        comentari = ""
        codiSem = ""
        uid = ""
        poblacio = ""
        carrer = ""
        numero = ""
        imatge = ""
        selectedImage = nil
    }
    
    func saveImage() {
        imageViewModel.uploadPhoto(image: selectedImage) { result in
            switch result {
            case .success(let path):
                imatge = path
                saveAlert()
                print("Uploaded successfully. Path: \(path)")
            case .failure(let error):
                mTitle = "Error"
                mMessage = error.localizedDescription
                isLoading = false
                showAlert.toggle()
                print("Failed to upload: \(error.localizedDescription)")
            }
        }
    }
    
    func saveAlert() {
        alertsViewModel.createNewAlert(alert: AlertsModel(codiSem: codiSem, prioritat: prioritat, uid: uid, nom: nom, adreça: [poblacio, carrer, numero], comentari: comentari, imatge: imatge, codiDiagnostic: "", nomDiagnostic: "", horaInici: "", horaEntrada: "", horaSortida: "")) { success in
            isLoading = false
            if success {
                print("new alert created in collection")
                mTitle = "Nova Alert Creada"
                mMessage = "S'ha creat l'alerta correctament"
                clearData()
                showAlert.toggle()
                appState.selectedIndex = 0 
            } else {
                mTitle = "Error"
                mMessage = alertsViewModel.messageError ?? "error"
                showAlert.toggle()
                print("Error")
            }
        }
    }
}

#Preview {
    AlertsNewView()
        .environmentObject(AppState()) // Add this line
}
