//
//  AlertsViewModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import AudioToolbox

final class AlertsViewModel: ObservableObject {
    @Published var alerts: [AlertsModel] = []
    @Published var alert: AlertsModel?
    @Published var messageError: String?

    private var previousAlerts: [String: AlertsModel] = [:]
    private var alertsRepository = CollectionRepository<AlertsModel>(collection: "alerts")

    init(alertsRepository: CollectionRepository<AlertsModel> = CollectionRepository(collection: "alerts")) {
        self.alertsRepository = alertsRepository
    }

    func getAllAlerts() {
        Firestore.firestore().collection("alerts").getDocuments { snapshot, error in
            if let error = error {
                self.messageError = error.localizedDescription
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.alerts = documents.compactMap { doc in
                do {
                    return AlertsModel(
                        id: doc.documentID,
                        codiSem: try EncryptionHelper.decrypt(doc["codiSem"] as? String ?? ""),
                        prioritat: try EncryptionHelper.decrypt(doc["prioritat"] as? String ?? ""),
                        uid: try EncryptionHelper.decrypt(doc["uid"] as? String ?? ""),
                        nom: try EncryptionHelper.decrypt(doc["nom"] as? String ?? ""),
                        adreça: try EncryptionHelper.decrypt(doc["adreça"] as? String ?? "").components(separatedBy: ";"),
                        comentari: try? EncryptionHelper.decrypt(doc["comentari"] as? String ?? ""),
                        imatge: try? EncryptionHelper.decrypt(doc["imatge"] as? String ?? ""),
                        codiDiagnostic: try? EncryptionHelper.decrypt(doc["codiDiagnostic"] as? String ?? ""),
                        nomDiagnostic: try? EncryptionHelper.decrypt(doc["nomDiagnostic"] as? String ?? ""),
                        horaInici: try? EncryptionHelper.decrypt(doc["horaInici"] as? String ?? ""),
                        horaEntrada: try? EncryptionHelper.decrypt(doc["horaEntrada"] as? String ?? ""),
                        horaSortida: try? EncryptionHelper.decrypt(doc["horaSortida"] as? String ?? "")
                    )
                } catch {
                    print("Error decrypting alert: \(error)")
                    return nil
                }
            }
        }
    }

    func getAlertsForUid(uid: String) {
        self.getAllAlerts()
        self.alerts = self.alerts.filter { $0.uid == uid }
    }

    func createNewAlert(alert: AlertsModel, completion: @escaping (Bool) -> Void) {
        do {
            let data: [String: Any] = [
                "codiSem": try EncryptionHelper.encrypt(alert.codiSem),
                "prioritat": try EncryptionHelper.encrypt(alert.prioritat),
                "uid": try EncryptionHelper.encrypt(alert.uid),
                "nom": try EncryptionHelper.encrypt(alert.nom),
                "adreça": try EncryptionHelper.encrypt(alert.adreça.joined(separator: ";")),
                "comentari": try EncryptionHelper.encrypt(alert.comentari ?? ""),
                "imatge": try EncryptionHelper.encrypt(alert.imatge ?? ""),
                "codiDiagnostic": try EncryptionHelper.encrypt(alert.codiDiagnostic ?? ""),
                "nomDiagnostic": try EncryptionHelper.encrypt(alert.nomDiagnostic ?? ""),
                "horaInici": try EncryptionHelper.encrypt(alert.horaInici ?? ""),
                "horaEntrada": try EncryptionHelper.encrypt(alert.horaEntrada ?? ""),
                "horaSortida": try EncryptionHelper.encrypt(alert.horaSortida ?? "")
            ]

            Firestore.firestore().collection("alerts").addDocument(data: data) { error in
                if let error = error {
                    self.messageError = error.localizedDescription
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            self.messageError = "Error encrypting alert: \(error.localizedDescription)"
            completion(false)
        }
    }

    func deleteAlert(_ alert: AlertsModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = alert.id else {
            completion(.failure(NSError(domain: "DeleteAlert", code: 0, userInfo: [NSLocalizedDescriptionKey: "Alert ID is nil"])))
            return
        }

        Firestore.firestore().collection("alerts").document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func updateAlert(alert: AlertsModel, completion: @escaping (Bool) -> Void) {
        guard let id = alert.id else {
            self.messageError = "Alert ID is nil"
            completion(false)
            return
        }

        do {
            let data: [String: Any] = [
                "codiSem": try EncryptionHelper.encrypt(alert.codiSem),
                "prioritat": try EncryptionHelper.encrypt(alert.prioritat),
                "uid": try EncryptionHelper.encrypt(alert.uid),
                "nom": try EncryptionHelper.encrypt(alert.nom),
                "adreça": try EncryptionHelper.encrypt(alert.adreça.joined(separator: ";")),
                "comentari": try EncryptionHelper.encrypt(alert.comentari ?? ""),
                "imatge": try EncryptionHelper.encrypt(alert.imatge ?? ""),
                "codiDiagnostic": try EncryptionHelper.encrypt(alert.codiDiagnostic ?? ""),
                "nomDiagnostic": try EncryptionHelper.encrypt(alert.nomDiagnostic ?? ""),
                "horaInici": try EncryptionHelper.encrypt(alert.horaInici ?? ""),
                "horaEntrada": try EncryptionHelper.encrypt(alert.horaEntrada ?? ""),
                "horaSortida": try EncryptionHelper.encrypt(alert.horaSortida ?? "")
            ]

            Firestore.firestore().collection("alerts").document(id).setData(data) { error in
                if let error = error {
                    self.messageError = error.localizedDescription
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            self.messageError = "Error encrypting alert: \(error.localizedDescription)"
            completion(false)
        }
    }

    func playNotificationSound() {
        AudioServicesPlaySystemSound(1007)
    }
}
