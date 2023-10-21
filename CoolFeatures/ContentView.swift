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
               
            MainButton {
                    isPresented.toggle()
            }
            
        }
//        .bottomSheet(isPresented: $isPresented, minDetention: .medium, maxDetention: .fraction(0.8)) {
//            MediumContent()
//        }
        .sheet(isPresented: $isPresented, content: {
            MediumContent()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
