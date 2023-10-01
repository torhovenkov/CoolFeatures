//
//  BottomSheetiOS16.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 29.09.2023.
//

import SwiftUI

struct BottomSheetiOS16: View {
    @State var isShowBottomSheet: Bool = false
    
    var body: some View {
        MainButton { isShowBottomSheet.toggle() }
            .sheet(isPresented: $isShowBottomSheet) {
                MediumContent()
                    .presentationDetents([.medium, .fraction(0.7)])
                    .presentationDragIndicator(.visible)
            }
        
    }
}

#Preview {
    ZStack {
        ImageBackground()
        
        BottomSheetiOS16()
    }
}

