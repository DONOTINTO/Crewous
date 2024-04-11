//
//  Button++.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit

extension UIButton {
    
    func custom(title: String, titleColor: UIColor, bgColor: UIColor) {
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.titleLabel?.font = FontManager.getFont(scale: .bold, size: .large)
    }
    
    func animate() {
        
        UIButton.animate(withDuration: 0.03, delay: 0, options: .autoreverse , animations: {
            self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        }, completion: { _ in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
