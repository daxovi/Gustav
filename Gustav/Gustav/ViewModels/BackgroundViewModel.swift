//
//  BackgroundViewModel.swift
//  Gustav
//
//  Created by Dalibor Janeček on 27.02.2022.
//

import Foundation
import SwiftUI

class BackgroundViewModel: ObservableObject {
    
    @Published var selectedImage: Int
    
    var images: [ImageModel]

    init() {
        images = [
            ImageModel(image: .none),
            ImageModel(image: .boxer),
            ImageModel(image: .bike),
            ImageModel(image: .dance),
            ImageModel(image: .pullup),
            ImageModel(image: .training)
        ]

            self.selectedImage = 1
    }
    
    func getBackgroundImage(image: Int) -> Image {
        return Image("\(images[image].getImageName())")
    }
    
    func getBackgroundThumbnail(image: Int) -> Image {
        return Image("\(images[image].getThumbnailName())")
    }
    
    func selectImage(imageNumber: Int) {
        self.selectedImage = imageNumber
    }
}
