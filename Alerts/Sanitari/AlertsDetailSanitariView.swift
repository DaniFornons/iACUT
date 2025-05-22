//
//  AlertsDatilSanitariView.swift
//  acut
//
//  Created by Dani Fornons on 6/6/24.
//

import SwiftUI
import MapKit

struct AlertsDetailSanitariView: View {
    var alert: AlertsModel
    @StateObject var imageViewModel: ImageViewModel = ImageViewModel()
    @StateObject var alertsViewModel: AlertsViewModel = AlertsViewModel()
    @StateObject var codesViewModel: CodesViewModel = CodesViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var horaInici = ""
    @State private var horaEntrada = ""
    @State private var horaSortida = ""
    //@State private var comentari = ""
    @State private var codiDiagnostic = ""
    @State private var nomDiagnostic = ""
    @State private var currentButton: String?
    
    @State private var showAlert: Bool = false
    @State private var showAlertUpdate: Bool = false
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
                        VStack(alignment: .leading) {
                            Text("Adreça").bold()
                            
                            Button("Obrir a Maps"){
                                openInMaps()
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(alert.adreça[0])
                            Text(alert.adreça[1]+" "+alert.adreça[2])
                        }
                    }
                }
                Section ("Control Horari"){
                    HStack {
                        Button(action: {
                            if !horaInici.isEmpty {
                                currentButton = "horaInici"
                                showAlertUpdate.toggle()
                            } else {
                                horaInici = getCurrentTime()
                            }
                        }, label: {
                            Text("Hora Inici").bold()
                        })
                        Spacer()
                        Text(horaInici)
                    }
                    if !horaInici.isEmpty{
                        HStack{
                            Button(action: {
                                if !horaEntrada.isEmpty {
                                    currentButton = "horaEntrada"
                                    showAlertUpdate.toggle()
                                } else {
                                    horaEntrada = getCurrentTime()
                                }
                            }, label: {
                                Text("Hora Entrada").bold()
                            })
                            Spacer()
                            Text(horaEntrada)
                        }
                    }
                    if !horaEntrada.isEmpty{
                        HStack{
                            Button(action: {
                                if !horaSortida.isEmpty {
                                    currentButton = "horaSortida"
                                    showAlertUpdate.toggle()
                                } else {
                                    horaSortida = getCurrentTime()
                                }
                            }, label: {
                                Text("Hora Sortida").bold()
                            })
                            Spacer()
                            Text(horaSortida)
                        }
                    }
                    
                }
                .alert(isPresented: $showAlertUpdate) {
                    Alert(
                        title: Text("Alerta"),
                        message: Text("Esteu segurs que voleu sobreescriure la hora?"),
                        primaryButton: .default(Text("Si")) {
                            if currentButton == "horaInici" {
                                horaInici = getCurrentTime()
                            } else if currentButton == "horaEntrada" {
                                horaEntrada = getCurrentTime()
                            } else if currentButton == "horaSortida" {
                                horaSortida = getCurrentTime()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                Section("Diagnòstic"){
                    Picker(codiDiagnostic, selection: $codiDiagnostic) {
                        Text("Introduïu Diagnòstic").tag(String?.none)
                        ForEach(codesViewModel.codes.sorted(by: { $0.text < $1.text })) { code in
                            Text(code.text).tag(code.code)
                        }
                    }
                    .onChange(of: codiDiagnostic) {
                        if let selectedCode = codesViewModel.codes.first(where: { $0.code == codiDiagnostic }) {
                            nomDiagnostic = selectedCode.text
                        }
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        updateAlert()
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
        }
        .onAppear {
            codesViewModel.getAllCodes()
            
            if let imagePath = alert.imatge {
                imageViewModel.retrievePhoto(path: imagePath)
            }
            horaInici = alert.horaInici ?? ""
            horaEntrada = alert.horaEntrada ?? ""
            horaSortida = alert.horaSortida ?? ""
            //comentari = alert.comentari ?? ""
            codiDiagnostic = alert.codiDiagnostic ?? ""
        }
    }
    func updateAlert() {
        let newalert = AlertsModel(
            id:alert.id,
            codiSem: alert.codiSem,
            prioritat: alert.prioritat,
            uid: alert.uid,
            nom: alert.nom,
            adreça: alert.adreça,
            comentari: alert.comentari,
            imatge: alert.imatge,
            codiDiagnostic: codiDiagnostic,
            nomDiagnostic: nomDiagnostic,
            horaInici: horaInici,
            horaEntrada: horaEntrada,
            horaSortida: horaSortida
        )
        if !horaSortida.isEmpty && codiDiagnostic.isEmpty{
            mError="Cal que introduïu un codi de diagnòstic"
            showAlert.toggle()
        }else{
            alertsViewModel.updateAlert(alert: newalert) { success in
                if success {
                    dismiss()
                } else {
                    mError = alertsViewModel.messageError ?? "Unknown error"
                    showAlert.toggle()
                }
            }
        }
    }
    
    func openInMaps() {
        let addressString = "\(alert.adreça[1]) \(alert.adreça[2]), \(alert.adreça[0])"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let placemarks = placemarks, let location = placemarks.first?.location {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                mapItem.name = "Domicili Alerta"
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
        }
    }
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: Date())
        
    }
    
}

#Preview {
    let alert = AlertsModel(
        codiSem: "001",
        prioritat: "P4",
        uid: "zrkYWEcE7Q33218ngnX4",
        nom: "Dani Fornons",
        adreça: ["La Pobla de Segur", "Av. Catalunya", "6"],
        comentari: "És Urgent",
        imatge: nil,
        codiDiagnostic: "",
        nomDiagnostic: "Nom malaltia",
        horaInici: "08:00",
        horaEntrada: "08:30",
        horaSortida: "09:00"
    )
    
    return AlertsDetailSanitariView(alert: alert)
}
