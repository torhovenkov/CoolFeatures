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
        Button {
            isShowBottomSheet.toggle()
        } label: {
            buttonLabel
        }
        .sheet(isPresented: $isShowBottomSheet) {
            HStack {
                ForEach(0..<5) { index in
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.cyan)
                        .overlay {
                            Text("\(index)")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                }
            }
            .presentationDetents([.fraction(0.7), .fraction(0.3)])
            .presentationDragIndicator(.visible)
        }

    }
    
    var buttonLabel: some View {
        Text("Tap me")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(Color.pink)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}



struct BottomSheetiOS16_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(colors: [.blue, .yellow], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            BottomSheetiOS16()
        }
    }
}
