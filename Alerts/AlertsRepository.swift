//
//  AlertsRepository.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation

final class AlertsRepository{
    private let alertsDataSource: CollectionFirebaseDatasource
    private let collection : String = "alerts"
    init(alertsDataSource: CollectionFirebaseDatasource = CollectionFirebaseDatasource()){
        self.alertsDataSource = alertsDataSource
    }
    func getAllAlerts(completionBlock:@escaping(Result<[AlertsModel], Error>) -> Void) {
        alertsDataSource.getAllData(toCollection: collection, completionBlock: completionBlock)
    }
}
