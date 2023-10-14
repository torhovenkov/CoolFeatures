//
//  BottomSheet2.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 14.10.2023.
//

import SwiftUI

struct BottomSheet2<Content: View>: View {
    enum Detention: Hashable {
        case medium, large, fraction(Double)
        
        var height: Double {
            switch self {
            case .medium:
                0.4
            case .large:
                0.99
            case .fraction(let double):
                double
            }
        }
    }
    
    @Binding var isPresented: Bool
    var dragArea: CGFloat = 40
    var color: Color = .red
    let content: () -> Content
    
    @State private var screenHeight: CGFloat = 0
    @State private var extraHeight: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var currentHeight: CGFloat = 0
    
    var minHeight: CGFloat = 400
    var maxHeight: CGFloat = 700
    
    
    var isNeedOffset: Bool {
        currentHeight == minHeight
    }
    
    var minDragDistance: CGFloat {
        100
    }
    
    var cornerRadius: CGFloat {
        dragArea > 20 ? 20 : dragArea
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color.black
                    .ignoresSafeArea()
                    .opacity(isPresented ? 0.7 : 0)
                    .onTapGesture {
                        isPresented = false
                    }
                
                color
                    .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(.all, edges: .bottom)
                    .frame(maxHeight: currentHeight + extraHeight)
                    .overlay {
                            content()
                            .padding(.top, dragArea)
                    }
                    .offset(y: offsetY)
                    
                    .offset(y: isPresented ? 0 : currentHeight + geo.safeAreaInsets.bottom)
                    .overlay(alignment: .top) {
                        color
                            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                            .overlay(alignment: .top) {
                                Capsule()
                                    .fill(.secondary)
                                    .frame(width: 60, height: 7)
                                    .padding(5)
                            }
                            .frame(height: dragArea)
                            .offset(y: offsetY)
                            .offset(y: isPresented ? 0 : currentHeight + geo.safeAreaInsets.bottom)
                            .gesture(drag)
                    }
            }
            .onAppear {
                currentHeight = minHeight
            }
            .animation(.smooth, value: isPresented)
        }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { val in
                updateOffsetY(with: val)
                updateHeight(with: val)
            }
            .onEnded { val in
                setHeight(with: val)
                hideSheet()
            }
    }
    
    private func updateOffsetY(with value: DragGesture.Value) {
        offsetY = isNeedOffset ? max(0, value.translation.height) * 0.7 : 0
    }
    
    private func updateHeight(with value: DragGesture.Value) {
        withAnimation(.easeOut) {
            extraHeight = (isNeedOffset ? max(0, -value.translation.height) : -value.translation.height)
        }
    }
    
    private func setHeight(with value: DragGesture.Value) {
        if extraHeight > minDragDistance {
            increaseHeight()
        }
        
        if extraHeight < -minDragDistance {
            decreaseHeight()
        }
        
        if abs(extraHeight) <= minDragDistance && abs(offsetY) <= minDragDistance {
            print(extraHeight)
            withAnimation(.smooth) {
                offsetY = 0
                extraHeight = 0
            }
        }
        
        func increaseHeight() {
            currentHeight += abs(extraHeight)
            extraHeight = 0
            withAnimation(.smooth) {
                currentHeight = maxHeight
            }
        }
        
        func decreaseHeight() {
            if !isNeedOffset {
                currentHeight += extraHeight
                extraHeight = 0
                withAnimation(.interpolatingSpring) {
                    currentHeight = minHeight
                }
            }
        }
    }
    
    private func hideSheet() {
        if offsetY > minDragDistance {
            offsetY = 0
            isPresented = false
        }
    }
    
}

extension View {
    @ViewBuilder
    func bottomSheet2<Content: View>(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}, content: @escaping () -> Content) -> some View {
        
        ZStack {
            self
            
            BottomSheet2(isPresented: isPresented, content: content)
            
        }
    }
}

fileprivate struct testSheet: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            ImageBackground()
            
            MainButton {
                isPresented.toggle()
            }
        }
        .bottomSheet2($isPresented) {
            MediumContent()
        }
    }
}


#Preview {
    testSheet()
}
