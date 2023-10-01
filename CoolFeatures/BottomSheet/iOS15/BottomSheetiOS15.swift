//
//  BottomSheetiOS15.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 29.09.2023.
//

import SwiftUI

fileprivate struct SheetPreview: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            ImageBackground()
            
            MainButton() {
                withAnimation {
                    isPresented = true
                }
            }
            
            BottomSheetiOS15(isPresented: $isPresented) {
                //                Text("hi")
//                MediumContent()
//                    .padding()
                Color.red
            }
        }
    }
}

struct BottomSheetiOS15<Content: View>: View {
    enum Background {
        case material(UIBlurEffect.Style), color(Color)
    }
    
    @Binding var isPresented: Bool
    
    var cornerRadius: CGFloat = 20
    var background: Background = .color(.white)
    let content: () -> Content
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(isPresented ? 0.5 : 0)
                .transition(.opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            if isPresented {
                ZStack {
                    switch background {
                    case .material(let style):
                        BlurView(style: style)
                            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                            .ignoresSafeArea()
                    case .color(let color):
                        color
                            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                    }
                    
                    Capsule()
                        .fill(.gray)
                        .frame(width: 50, height: 5)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 5)
                    
                    content()
                        .padding(.top, cornerRadius < 15 ? 15 : cornerRadius)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    SheetPreview()
}
