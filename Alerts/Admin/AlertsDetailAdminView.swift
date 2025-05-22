//
//  AlertsDetailView.swift
//  acut
//
//  Created by Dani Fornons on 5/6/24.
//
//  AlertsDetailView.swift
//  acut
//
//  Created by Dani Fornons on 5/6/24.
//
import SwiftUI

struct AlertsDetailAdminView: View {
    var alert: AlertsModel
    @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
    @StateObject var alertsViewModel: AlertsViewModel = AlertsViewModel()
    @Environment(\.dismiss) var dismiss

    @State private var showAlert: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var mError : String = ""
    @State private var showImageFullScreen: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section("Alerta") {
                    HStack {
                        Text("CodiSEM").bold()
                        Spacer()
                        Text(alert.codiSem)
                    }
                    HStack {
                        Text("Prioritat").bold()
                        Spacer()
                        Text(alert.prioritat)
                    }
                    HStack {
                        Text("Professional").bold()
                        Spacer()
                        Text(alert.nom)
                    }
                    HStack {
                        Text("Adreça").bold()
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(alert.adreça[0])
                            Text(alert.adreça[1]+" "+alert.adreça[2])
                        }
                    }
                }
                    Section ("Control Horari"){
                        HStack {
                            Text("Hora Inici").bold()
                            Spacer()
                            Text(alert.horaInici ?? "")
                        }
                        HStack {
                            Text("Hora Entrada").bold()
                            Spacer()
                            Text(alert.horaEntrada ?? "")
                        }
                        HStack {
                            Text("Hora Sortida").bold()
                            Spacer()
                            Text(alert.horaSortida ?? "")
                        }
                    
                }
                Section("Diagnòstic"){
                    HStack{
                        Text(alert.codiDiagnostic ?? "Codi").bold()
                        Spacer()
                        Text(alert.nomDiagnostic ?? "")
                    }
                    
                }
                
                Section("Informació Addicional") {
                    Text(alert.comentari ?? "")
                    if let image = imageViewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                showImageFullScreen = true
                            }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"),
                                  message: Text(mError),
                                  dismissButton: .default(Text("OK")))
                        }
            .sheet(isPresented: $showImageFullScreen) {
                            ImageFullScreeView(image: imageViewModel.image)
                        }
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        showConfirmation.toggle()
                    }) {
                        Image(systemName: "trash")
                    }.alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Status"),
                            message: Text("Segur que voleu eliminar aquesta alerta"),
                            primaryButton: .destructive(Text("Borrar")) {
                                alertsViewModel.deleteAlert(alert) { result in
                                        switch result {
                                        case .success():
                                            dismiss()
                                        case .failure(let error):
                                            mError = error.localizedDescription
                                            showAlert = true
                                        }
                                    }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
           }
        .onAppear {
            if let imagePath = alert.imatge {
                imageViewModel.retrievePhoto(path: imagePath)
            }
        }
    }
}

#Preview {
    let alert = AlertsModel(
        codiSem: "001",
        prioritat: "P4",
        uid: "zrkYWEcE7Q33218ngnX4",
        nom: "Dani Fornons",
        adreça: ["Pobla", "Av. Catalunya", "6"],
        comentari: "És Urgent",
        imatge: nil,
        codiDiagnostic: "A01",
        nomDiagnostic: "Nom malaltia",
        horaInici: "08:00",
        horaEntrada: "08:30",
        horaSortida: "09:00"
    )

    return AlertsDetailAdminView(alert: alert)
}
