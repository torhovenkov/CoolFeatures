//
//  CustomContent.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 06.12.2023.
//

import SwiftUI

struct CustomContent: View {
    var body: some View {
        Color.blue
            .frame(height: 300)
            .padding(.top, 20)
            .overlay {
                Text("Content height 300")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .background {
                Color.white
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(.all, edges: .bottom)
            }
    }
}

#Preview {
    CustomContent()
}
