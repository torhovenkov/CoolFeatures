//
//  BottomSheet2.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 14.10.2023.
//

import SwiftUI

struct BottomSheet2: View {
    let heights: [CGFloat] = [400, 700]
    
    var isNeedOffset: Bool {
        minHeight == heights.min() ?? 0
    }
    
    @State private var extraHeight: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var minHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ImageBackground()
            
            Color.white
                .ignoresSafeArea(.all, edges: .bottom)
                .frame(maxHeight: minHeight + extraHeight)
                .overlay {
                    MediumContent()
                }
                .offset(y: offsetY)
                .gesture(drag)
            
        }
        .onAppear {
            minHeight = heights.min() ?? 0
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
                
            }
    }
    
    func updateOffsetY(with value: DragGesture.Value) {
        offsetY = isNeedOffset ? max(0, value.translation.height) * 0.7 : 0
    }
    
    func updateHeight(with value: DragGesture.Value) {
        withAnimation(.easeOut) {
            extraHeight = (isNeedOffset ? max(0, -value.translation.height) : -value.translation.height)
        }
    }
    
    func setHeight(with value: DragGesture.Value) {
        if extraHeight > 100 {
            increaseHeight()
        }
        
        if extraHeight < -100 {
            decreaseHeight()
        }
        
        if abs(extraHeight) <= 100 {
            withAnimation(.smooth) {
                reset()
            }
        }
        
        func increaseHeight() {
            minHeight += abs(extraHeight)
            extraHeight = 0
            withAnimation(.smooth) {
                minHeight = heights.max() ?? 0
            }
        }
        
        func decreaseHeight() {
            minHeight += extraHeight
            extraHeight = 0
            withAnimation(.interpolatingSpring) {
                minHeight = heights.min() ?? 0
            }
        }
    }
    
    private func reset() {
        offsetY = 0
        extraHeight = 0
    }
    
}

#Preview {
    BottomSheet2()
}
