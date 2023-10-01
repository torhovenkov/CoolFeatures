//
//  PictureBackground.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 30.09.2023.
//

import SwiftUI

struct ImageBackground: View {
    var body: some View {
        GeometryReader { geo in
            Image("photo")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ImageBackground()
}
