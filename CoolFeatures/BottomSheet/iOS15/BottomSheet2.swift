//
//  BottomSheet2.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 14.10.2023.
//

import SwiftUI

struct BottomSheet2: View {
    @State var isPresented: Bool = true
    @State private var extraHeight: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var minHeight: CGFloat = 0
    
    let heights: [CGFloat] = [400, 700]
    
    var isNeedOffset: Bool {
        minHeight == heights.min() ?? 0
    }
    
    var minDragDistance: CGFloat {
        100
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
            
            Color.white
                .ignoresSafeArea(.all, edges: .bottom)
                .frame(maxHeight: minHeight + extraHeight)
                .overlay {
                    MediumContent()
                }
                .offset(y: offsetY)
                .gesture(drag)
                .alignmentGuide(.bottom) {
                    isPresented ? $0[.bottom] : $0[.top] - geo.safeAreaInsets.bottom
                }
            
        }
        .onAppear {
            minHeight = heights.min() ?? 0
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
    
    func updateOffsetY(with value: DragGesture.Value) {
        offsetY = isNeedOffset ? max(0, value.translation.height) * 0.7 : 0
    }
    
    func updateHeight(with value: DragGesture.Value) {
        withAnimation(.easeOut) {
            extraHeight = (isNeedOffset ? max(0, -value.translation.height) : -value.translation.height)
        }
    }
    
    func setHeight(with value: DragGesture.Value) {
        if extraHeight > minDragDistance {
            increaseHeight()
        }
        
        if extraHeight < -minDragDistance {
            decreaseHeight()
        }
        
        if abs(extraHeight) <= minDragDistance && abs(offsetY) <= minDragDistance {
            print(extraHeight)
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
            if !isNeedOffset {
                minHeight += extraHeight
                extraHeight = 0
                withAnimation(.interpolatingSpring) {
                    minHeight = heights.min() ?? 0
                }
            }
        }
    }
    
    func hideSheet() {
        if offsetY > minDragDistance {
            offsetY = 0
            isPresented = false
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
