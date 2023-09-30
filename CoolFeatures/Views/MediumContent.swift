//
//  MediumContent.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 30.09.2023.
//

import SwiftUI

struct MediumContent: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundStyle(.blue)
            Rectangle()
                .foregroundStyle(.yellow)
        }
        .frame(maxHeight: 300)
        .padding(0)
        .overlay {
            ZStack {
                Color.black
                    .opacity(0.5)
                
                Text("Pray for Ukraine")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    MediumContent()
}
