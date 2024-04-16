//
//  TextField++.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit

extension UITextField {
    
    func custom(placeholder: String, imageStr: String) {
        
        guard let customPaddingImageView = makeCustomImageView(imageStr: imageStr) else { return }
        
        self.leftViewMode = .always
        self.leftView = customPaddingImageView
        self.textColor = .white
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.customGray])
        self.placeholder = placeholder
        self.backgroundColor = .customBlue
        self.font = .systemFont(ofSize: 15, weight: .regular)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.autocapitalizationType = .none
    }
    
    func custom(placeholder: String, fontSize: FontManager.FontSize) {
        
        self.textColor = .white
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.customGray])
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: fontSize.rawValue, weight: .regular)
        self.autocapitalizationType = .none
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.customGray.cgColor
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        self.layer.cornerRadius = 10
    }
    
    func makeCustomImageView(imageStr: String) -> UIView? {
        
        // 커스텀 이미지 생성
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        guard let customImage = UIImage(systemName: imageStr)?.withTintColor(.customGray, renderingMode: .alwaysOriginal).withConfiguration(configuration) else {
            return nil
        }
        
        // 커스텀 패딩 레이아웃 안에 이미지 삽입
        let frame = CGRect(x: 0, y: 0, width: 50, height: customImage.size.height)
        let paddingLayoutView = UIView(frame: frame)
        let paddingImage = UIImageView(frame: frame)
        
        paddingImage.image = customImage
        paddingImage.contentMode = .center
        paddingLayoutView.addSubview(paddingImage)
        
        return paddingLayoutView
    }
}
