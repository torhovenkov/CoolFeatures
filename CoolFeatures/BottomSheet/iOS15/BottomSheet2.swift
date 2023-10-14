//
//  BottomSheet2.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 14.10.2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        dragArea: CGFloat = 40,
        color: Color = .white,
        detention: Detention = .large,
        isShowDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        overlay {
            BottomSheet(isPresented: isPresented, dragArea: dragArea, color: color, detention: detention, isShowDragIndicator: isShowDragIndicator, content: content)
        }
    }
    @ViewBuilder
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        dragArea: CGFloat = 40,
        color: Color = .white,
        minDetention: Detention,
        maxDetention: Detention,
        isShowDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        overlay {
            BottomSheet(isPresented: isPresented, dragArea: dragArea, color: color, minDetention: minDetention, maxDetention: maxDetention, isShowDragIndicator: isShowDragIndicator, content: content)
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
        .bottomSheet(isPresented: $isPresented, dragArea: 40, color: .white, minDetention: .fraction(0.4), maxDetention: .fraction(0.7), isShowDragIndicator: true) {
            SmallContent()
        }
        
    }
}

fileprivate
struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let dragArea: CGFloat
    let color: Color
    let detention: (min: Detention, max: Detention)
    let isShowingDragIndicator: Bool
    let content: () -> Content
    
    init(
        isPresented: Binding<Bool>,
        dragArea: CGFloat,
        color: Color,
        detention: Detention,
        isShowDragIndicator: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.dragArea = dragArea
        self.color = color
        self.detention = (detention, detention)
        self.isShowingDragIndicator = isShowDragIndicator
        self.content = content
    }
    
    init(
        isPresented: Binding<Bool>,
        dragArea: CGFloat = 0,
        color: Color = .white,
        minDetention: Detention,
        maxDetention: Detention,
        isShowDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.dragArea = dragArea
        self.color = color
        self.detention = (min(minDetention, maxDetention), max(minDetention, maxDetention))
        self.isShowingDragIndicator = isShowDragIndicator
        self.content = content
    }
    
    @State private var screenHeight: CGFloat = 0
    @State private var extraHeight: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var currentHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color.black
                    .ignoresSafeArea()
                    .opacity(isPresented ? 0.7 : 0)
                    .onTapGesture {
                        isPresented = false
                        currentHeight = minHeight
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
                        Color.white.opacity(0.0001)
                            .overlay(alignment: .top) {
                                dragIndicator
                            }
                            .frame(height: dragArea)
                            .offset(y: offsetY)
                            .offset(y: isPresented ? 0 : currentHeight + geo.safeAreaInsets.bottom)
                            .gesture(drag)
                    }
            }
            .onAppear {
                screenHeight = geo.size.height
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
    
    var dragIndicator: some View {
        Capsule()
            .fill(.secondary
                .opacity(isShowingDragIndicator ? 1 : 0))
            .frame(width: 60, height: 7)
            .padding(5)
    }
    
    var minHeight: CGFloat {
        screenHeight * detention.min.height
    }
    var maxHeight: CGFloat {
        screenHeight * detention.max.height
    }
    var isNeedOffset: Bool {
        currentHeight == minHeight
    }
    var minDragDistance: CGFloat {
        minHeight == maxHeight ? 100 : min(100, (maxHeight - minHeight) * 0.33)
    }
    var cornerRadius: CGFloat {
        dragArea > 20 ? 20 : dragArea
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


enum Detention: Hashable, Comparable {
case medium, large, fraction(Double)

var height: Double {
    switch self {
    case .medium:
        0.5
    case .large:
        0.99
    case .fraction(let double):
        double
    }
}

static func <(lhs: Detention, rhs: Detention) -> Bool {
    lhs.height < rhs.height
}

static func >(lhs: Detention, rhs: Detention) -> Bool {
    lhs.height > rhs.height
}
}


#Preview {
    testSheet()
}
