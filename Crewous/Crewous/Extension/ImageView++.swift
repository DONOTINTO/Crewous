//
//  ImageView++.swift
//  Crewous
//
//  Created by 이중엽 on 4/18/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from image: String, placeHolderImage: UIImage? = nil) {
        
        let url = URL(string: "http://lslp.sesac.kr:8244/v1/" + image)
        
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UDManager.accessToken, forHTTPHeaderField: HTTPHeader.Key.authorization.rawValue)
            request.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.Key.sesacKey.rawValue)
            return request
        }
        self.kf.setImage(with: url, placeholder: placeHolderImage, options: [.requestModifier(modifier), .forceRefresh])
    }
}
