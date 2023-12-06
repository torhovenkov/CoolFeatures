//
//  Effect.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 09.10.2023.
//

import SwiftUI

struct EffectPreview: View {
    @State var isCircle = false
    
    var body: some View {
        ZStack {
            ImageBackground()
            
            MainButton {
                isCircle.toggle()
            }
            
            Effect(isCircle: $isCircle)
                .offset(y: 200)
        }
    }
}

struct Effect: View {
    @Namespace private var nm
    @Binding var isCircle: Bool
    
    var body: some View {
        VStack {
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .overlay {
                    if isCircle {
                        Circle()
                            .fill(.blue)
                            .matchedGeometryEffect(id: "id", in: nm, properties: .position)
                            .overlay {
                                ProgressView()
                                    .scaleEffect(2)
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.blue)
                            .overlay {
                                if !isCircle {
                                    Text("Not loading")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                }
                            }
                            .matchedGeometryEffect(id: "id", in: nm)
                    }
                }
        }
        .animation(.easeInOut, value: isCircle)
    }
}

#Preview {
    EffectPreview()
}
