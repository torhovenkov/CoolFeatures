//
//  LargeContent.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 30.09.2023.
//

import SwiftUI

struct LargeContent: View {
    struct Contact: Identifiable {
        let id = UUID()
        let name: String
        var isFavorite: Bool = false
    }
    
    @State var date: Date = Date()
    
    var contacts: [Contact] = [
        Contact(name: "Vlad", isFavorite: true),
        Contact(name: "Igor"),
        Contact(name: "Sergey", isFavorite: true),
        Contact(name: "Rostislav")
    ]
    
    var body: some View {
        List {
            Section {
                ForEach(contacts) { contact in
                    HStack {
                        Text(contact.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if contact.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
            Section {
                DatePicker("Pick Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
    }
}

#Preview {
    LargeContent()
}
