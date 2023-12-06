//
//  BottomSheetiOS15.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 29.09.2023.
//

import SwiftUI

struct BottomSheetiOS15<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            Color.black
                .ignoresSafeArea()
                .opacity(isPresented ? 0.7 : 0)
                .animation(.easeInOut, value: isPresented)
                .onTapGesture {
                    isPresented = false
                }
                .overlay(alignment: .bottom) {
                    content()
                        .scaleEffect(scale, anchor: .bottom)
                        .offset(y: max(0, offsetY))
                        .gesture(drag)
                        .alignmentGuide(.bottom) {
                            isPresented ? $0[.bottom] : $0[.top] - geo.safeAreaInsets.bottom
                        }
                        .animation(.smooth(duration: 0.35), value: isPresented)
                }
        }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { val in
                let height = val.translation.height < 0 ? val.translation.height * 0.2 : val.translation.height
                offsetY = max(-50, height)
            }
            .onEnded { val in
                if val.translation.height > 100 {
                    offsetY = 0
                    isPresented = false
                } else {
                    withAnimation {
                        offsetY = 0
                    }
                }
            }
    }
    
    var scale: CGSize {
        CGSize(width: 1, height: offsetY < 0 ? 1 + abs(offsetY / 1000) : 1)
    }
}

#Preview {
    ContentView()
}

extension View {
    @ViewBuilder
    func customSheet<Content: View>(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}, content: @escaping () -> Content) -> some View {
        
        ZStack {
            self
            
            BottomSheetiOS15(isPresented: isPresented, content: content)
        }
    }
}
