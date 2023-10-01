//
//  View+Extension.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 01.10.2023.
//

import SwiftUI

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self
            .clipShape(CustomCorner(corners: corners, radius: radius))
    }
}
