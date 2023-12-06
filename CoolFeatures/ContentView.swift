//
//  ContentView.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 28.09.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false
    @State var isPresented2 = false
    
    var body: some View {
        ZStack {
            ImageBackground()
               
            VStack(spacing: 30) {
                MainButton(title: "Simple sheet") {
                        isPresented.toggle()
                }
                
                MainButton(title: "Resizable Sheet") {
                    isPresented2.toggle()
                }
            }
            
        }
        .customSheet($isPresented) {
            CustomContent()
        }
        .bottomSheet(isPresented: $isPresented2, minDetention: .fraction(0.3), maxDetention: .fraction(0.8)) {
            SmallContent()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
