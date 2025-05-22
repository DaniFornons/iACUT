//
//  AlertsView.swift
//  acut
//
//  Created by Dani Fornons on 22/5/24.
//

import SwiftUI
struct UsersView: View {
    @ObservedObject var usersViewModel: UsersViewModel
    
    
    var body: some View {
        VStack {
            
            List {
                    Text("Usuaris:")
                        .font(.title)
            
                ForEach(usersViewModel.users){ user in
                    HStack{
                        
                        Text(user.name ?? "No Name")
                        Spacer()
                        Text(user.email )
                            .bold()
                    }
                    
                }
            }
            .task {
                usersViewModel.getAllUsers()
            }
        }
    }
}

#Preview {
    UsersView(usersViewModel: UsersViewModel())
}

