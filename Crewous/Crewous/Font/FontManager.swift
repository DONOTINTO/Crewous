//
//  FontManager.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit.UIFont

enum FontManager {
    
    enum FontSize: CGFloat {
        
        case tiny = 11
        case small = 15
        case medium = 20
        case regular = 25
        case large = 30
    }
    
    enum FontScale: String {
        
        case black = "Black"
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case headLine = "Headline"
        case light = "Light"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case semiLight = "SemiLight"
        case thin = "Thin"
    }
    
    static func getFont(scale: FontScale, size: FontSize) -> UIFont {
        
        let font = UIFont(name: "Blinker-\(scale)", size: size.rawValue) ?? .boldSystemFont(ofSize: size.rawValue)
        
        return font
    }
}
