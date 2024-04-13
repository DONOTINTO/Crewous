//
//  Label++.swift
//  Crewous
//
//  Created by 이중엽 on 4/14/24.
//

import UIKit

extension UILabel {
    
    func custom(title: String, color: UIColor, fontScale: FontManager.FontScale, fontSize: FontManager.FontSize) {
        
        self.text = title
        self.textColor = color
        self.font = FontManager.getFont(scale: fontScale, size: fontSize)
        self.adjustsFontSizeToFitWidth = true
    }
    
    func custom(title: String, color: UIColor, fontSize: CGFloat) {
        
        self.text = title
        self.textColor = color
        self.font = .systemFont(ofSize: fontSize)
        self.adjustsFontSizeToFitWidth = true
    }
}
