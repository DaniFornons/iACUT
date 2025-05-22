//  CodeView.swift
//  acut
//
//  Created by Dani Fornons on 22/5/24.
//

import SwiftUI

struct CodesView: View {
    @StateObject var codesViewModel: CodesViewModel = CodesViewModel()
    @State private var searchText = ""
    
    var filteredCodes: [CodesModel] {
        if searchText.isEmpty {
            return codesViewModel.codes
        } else {
            return codesViewModel.codes.filter { $0.text.localizedCaseInsensitiveContains(searchText) || $0.code.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCodes.sorted(by: { $0.text < $1.text })) { code in
                    HStack {
                        Text(code.text)
                        Spacer()
                        Text(code.code)
                            .bold()
                    }
                }
            }
            .searchable(text: $searchText)
            .task {
                codesViewModel.getAllCodes()
            }
            .navigationTitle("Codis")
        }
    }
}

#Preview {
    CodesView(codesViewModel: CodesViewModel())
}
