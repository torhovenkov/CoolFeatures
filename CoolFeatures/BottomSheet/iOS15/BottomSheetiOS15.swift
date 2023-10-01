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
                isPresented = true
            }
        }
        .customSheet($isPresented, completion: { print("Finished") }) {
            MediumContent()
        }
    }
}

extension View {
    @ViewBuilder
    func customSheet<Content: View>(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}, content: @escaping () -> Content) -> some View {
        
        ZStack {
            self
            
            BottomSheetiOS15(isPresented: isPresented, completion: completion, content: content)
            
        }
    }
}


struct BottomSheetiOS15<Content: View>: View {
    enum Background {
        case material(UIBlurEffect.Style), color(Color)
    }
    
    @Binding var isPresented: Bool
    
    @State private var screenHeight: CGFloat = 0
    @State private var safeAreaSize: CGFloat = 0
    
    var cornerRadius: CGFloat = 20
    var background: Background = .color(.white)
    var completion: () -> () = {}
    let content: () -> Content
    
    var halfScreen: CGFloat {
        screenHeight * 0.5
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(isPresented ? 0.5 : 0)
                .transition(.opacity)
                .ignoresSafeArea()
                .animation(.easeInOut, value: isPresented)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                safeAreaSize = geo.safeAreaInsets.bottom
                                screenHeight = geo.size.height
                            }
                    }
                }
                .onTapGesture {
                    isPresented = false
                }
            
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
            .frame(height: halfScreen)
            .offset(y: isPresented ? 0 : halfScreen + safeAreaSize)
            .animation(.smooth(duration: 0.35), value: isPresented)
        }
        .onChange(of: isPresented) { newValue in
            if !newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    completion()
                }
            }
        }
    }
}

#Preview {
    SheetPreview()
}
