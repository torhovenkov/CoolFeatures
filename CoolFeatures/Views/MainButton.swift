//
//  MainButton.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 29.09.2023.
//

import SwiftUI

struct MainButton: View {
    var title: String = "Tap me"
    var action: () -> () = {}
    
    var body: some View {
        Button(action: action) {
            buttonLabel
        }
    }
    
    var buttonLabel: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(Color.pink)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton()
    }
}
