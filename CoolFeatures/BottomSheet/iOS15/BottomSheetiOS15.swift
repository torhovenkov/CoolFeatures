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
    enum Detention {
        case medium, large, fraction(Double)
        
        var height: Double {
            switch self {
            case .medium:
                0.4
            case .large:
                0.8
            case .fraction(let height):
                height
            }
        }
    }
    
    @Binding var isPresented: Bool
    var detention: Detention = .large
    let completion: () -> ()
    
    @ViewBuilder let content: () -> Content

    @State private var offsetY: CGFloat = 0
    @State private var currentHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            Color.black
                .ignoresSafeArea()
                .opacity(isPresented ? 0.7 : 0)
                .animation(.easeInOut, value: isPresented)
                .onTapGesture {
                    isPresented = false
                }
                .onAppear { currentHeight = geo.size.height }
                .overlay(alignment: .bottom) {
                    Color.white
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()
                        .frame(height: detention.height * currentHeight)
                        .overlay {
                            content()
                                .padding(.top, 20)
                        }
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
    SheetPreview()
}
