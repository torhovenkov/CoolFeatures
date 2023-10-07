//
//  ContentView.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 28.09.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false
    
    var body: some View {
        ZStack {
            ImageBackground()
                .overlay {
                    MainButton(title: "Press me") {
                        isPresented = true
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
