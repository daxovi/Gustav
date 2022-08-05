//
//  ImageModel.swift
//  Gustav
//
//  Created by Dalibor Janeček on 27.02.2022.
//

import Foundation
import SwiftUI

enum BackgroundImage: String {
    case none
    case boxer
    case bike
    case dance
    case pullup
    case training
}

struct ImageModel: Identifiable {
    let id = UUID().uuidString
    var image: BackgroundImage
    
    func getImageName() -> String {
        return "\(image.rawValue)"
    }
    
    func getImage() -> Image {
        return Image("\(image.rawValue)")
    }
    
    func getThumbnailName() -> String {
        return "\(image.rawValue)_min"
    }
    
    func getThumbnail() -> Image {
        return Image("\(image.rawValue)_min").resizable()
    }
}
