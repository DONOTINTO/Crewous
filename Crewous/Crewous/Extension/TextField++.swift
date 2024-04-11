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
        self.font = FontManager.getFont(scale: .semiBold, size: .medium)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.autocapitalizationType = .none
    }
    
    func custom(title: String) {
        
    }
    
    func makeCustomImageView(imageStr: String) -> UIView? {
        
        // 커스텀 이미지 생성
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        guard let customImage = UIImage(systemName: imageStr)?.withTintColor(.customGray, renderingMode: .alwaysOriginal).withConfiguration(configuration) else {
            return nil
        }
        
        // 커스텀 패딩 레이아웃 안에 이미지 삽입
        let frame = CGRect(x: 0, y: 0, width: customImage.size.width + 30, height: customImage.size.height)
        let paddingLayoutView = UIView(frame: frame)
        let paddingImage = UIImageView(frame: frame)
        
        paddingImage.image = customImage
        paddingImage.contentMode = .center
        paddingLayoutView.addSubview(paddingImage)
        
        return paddingLayoutView
    }
}
