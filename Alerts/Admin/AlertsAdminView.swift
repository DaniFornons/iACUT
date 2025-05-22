//
//  AlertsView.swift
//  acut
//
//  Created by Dani Fornons on 22/5/24.
//
import SwiftUI

struct AlertsAdminView: View {
    @StateObject var alertsViewModel: AlertsViewModel = AlertsViewModel()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showNew = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(alertsViewModel.alerts.sorted(by: { $0.codiSem < $1.codiSem })) { alert in
                    NavigationLink(destination: AlertsDetailAdminView(alert: alert)) {
                        VStack(alignment: .leading) {
                            Text("SEM: \(alert.codiSem)").bold()
                            Text("Sanitari: "+alert.nom)
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
                alertsViewModel.getAllAlerts()
            }
            
            .navigationTitle("Alertes")
            .toolbar(){
                ToolbarItem{
                    Button(action: {
                        showNew.toggle()
                    }) {
                        
                        Image(systemName: "rectangle.center.inset.filled.badge.plus")
                    }
                }
                
            }
            
          
        }
        .sheet(isPresented: $showNew) {
                        AlertsNewView()
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
    AlertsAdminView(alertsViewModel: AlertsViewModel())
}
