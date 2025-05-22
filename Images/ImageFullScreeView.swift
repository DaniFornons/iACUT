//
//  FullScreenImageView.swift
//  acut
//
//  Created by Dani Fornons on 5/6/24.
//

import SwiftUI

struct ImageFullScreeView: View {
    var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("No image available")
            }
        }
    }
}

#Preview {
    ImageFullScreeView()
}
