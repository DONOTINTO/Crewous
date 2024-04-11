//
//  Button++.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit

extension UIButton {
    
    func custom(title: String, titleColor: UIColor, bgColor: UIColor) {
        
        self.configure(title: title, titleColor: titleColor, bgColor: bgColor)
    }
    
    private func configure(title: String, titleColor: UIColor, bgColor: UIColor) {
        
        var titleAttrribute = AttributedString.init(title)
        titleAttrribute.font = FontManager.getFont(scale: .bold, size: .large)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.background.backgroundColor = bgColor
        buttonConfiguration.baseForegroundColor = titleColor
        buttonConfiguration.background.cornerRadius = 20
        
        self.configuration = buttonConfiguration
        
        configureUpdateHandler(bgColor: bgColor)
    }
    
    private func configureUpdateHandler(bgColor: UIColor) {
        
        let updateHandler: UIButton.ConfigurationUpdateHandler = { btn in
            
            switch btn.state {
            case .disabled:
                btn.configuration?.background.backgroundColor = .systemGray
            default:
                btn.configuration?.background.backgroundColor = bgColor
            }
        }
        
        self.configurationUpdateHandler = updateHandler
    }
    
    func animate() {
        
        UIButton.animate(withDuration: 0.03, delay: 0, options: .autoreverse , animations: {
            self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        }, completion: { _ in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
