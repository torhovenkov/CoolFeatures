//
//  BlurView.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 29.09.2023.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}
