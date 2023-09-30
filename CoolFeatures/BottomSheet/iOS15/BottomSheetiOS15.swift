//
//  BottomSheetiOS15.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 29.09.2023.
//

import SwiftUI

struct BottomSheetiOS15: View {
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .overlay {
                        MainButton { isPresented.toggle() }
                    }
            }
            .ignoresSafeArea()
            
        }
    }
    
    var content: some View {
        VStack {
            HStack {
                Image(systemName: "heart.fill")
                Image(systemName: "house.fill")
                Image(systemName: "star.fill")
                Image(systemName: "person.fill")
            }
            .font(.largeTitle)
            .foregroundColor(.pink)
        }
    }
}



struct BottomSheetiOS15_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetiOS15()
    }
}
