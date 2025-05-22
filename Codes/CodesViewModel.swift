//
//  CodesViewModel.swift
//  acut
//
//  Created by Dani Fornons on 23/5/24.
//

import Foundation

final class CodesViewModel: ObservableObject{
    @Published var codes: [CodesModel] = []
    @Published var messageError : String?
    
    private var codesRepository = CollectionRepository<CodesModel>(collection: "codes")
    
    init(codesRepository : CollectionRepository<CodesModel> = CollectionRepository(collection: "codes")){
        self.codesRepository = codesRepository
    }
    
    func getAllCodes(){
        
        codesRepository.getAllData{ [weak self] result in
            switch result {
            case .success(let codesModels):
                self?.codes = codesModels
                
            case .failure(let error):
                self?.messageError = error.localizedDescription
                 
            }
        }
    }
    
}


