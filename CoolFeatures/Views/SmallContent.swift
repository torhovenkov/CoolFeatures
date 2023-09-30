//
//  SmallContent.swift
//  CoolFeatures
//
//  Created by Vladyslav Torhovenkov on 30.09.2023.
//

import SwiftUI

struct SmallContent: View {
    enum Images: CaseIterable, Hashable {
        case heart, house, star, person
        var name: String {
            switch self {
            case .heart: "heart"
            case .house: "house"
            case .star: "star"
            case .person: "person"
            }
        }
    }
    
    @State var selectedImages: Set<Images> = []
    
    var body: some View {
        HStack {
            Group {
                ForEach(Images.allCases, id: \.self) { image in
                    Image(systemName: isSelected(image) ? "\(image.name).fill" : image.name)
                        .padding(4)
                        .onTapGesture {
                            select(image)
                        }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .font(.largeTitle)
        .foregroundColor(.pink)
    }
    
    func isSelected(_ image: Images) -> Bool {
        selectedImages.contains(image)
    }
    
    func select(_ image: Images) {
        if isSelected(image) {
            selectedImages.remove(image)
            return
        }
        selectedImages.insert(image)
    }
}

#Preview {
    SmallContent()
}
