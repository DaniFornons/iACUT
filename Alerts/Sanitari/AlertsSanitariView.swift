//
//  AlertsSanitariView.swift
//  acut
//
//  Created by Dani Fornons on 6/6/24.
//

import SwiftUI

struct AlertsSanitariView: View {
    let uid: String
    @StateObject var alertsViewModel: AlertsViewModel = AlertsViewModel()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        
        NavigationStack {
            
            List {
                ForEach(alertsViewModel.alerts.sorted(by: { $0.codiSem < $1.codiSem })) { alert in
                    NavigationLink(destination: AlertsDetailSanitariView(alert: alert)) {
                        VStack(alignment: .leading) {
                            Text("SEM: \(alert.codiSem)").bold()
                            Text("Lloc: \(alert.adreça[0])")
                        }
                    }.padding()
                        .background(getColor(alerta: alert))
                        .cornerRadius(10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Status"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .task {
                alertsViewModel.getAlertsForUid(uid: uid)
            }
            .navigationTitle("Alertes")
        }
    }
    private func getColor(alerta:AlertsModel)-> Color
    {
        if !alerta.horaSortida!.isEmpty{
            return .blue
        }else if
            !alerta.horaEntrada!.isEmpty{
            return .yellow
        }else if !alerta.horaInici!.isEmpty{
            return .green
        }else {return Color.gray.opacity(0.2)
        }
    }
}

#Preview {
    AlertsSanitariView(uid: "H0JkmcQFbtTqAgMjWzsIp1O1W0I2")
}
