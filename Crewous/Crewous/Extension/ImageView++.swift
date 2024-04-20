//
//  ImageView++.swift
//  Crewous
//
//  Created by 이중엽 on 4/18/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from url: URL, placeHolderImage: UIImage? = nil) {
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UDManager.accessToken, forHTTPHeaderField: HTTPHeader.Key.authorization.rawValue)
            request.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.Key.sesacKey.rawValue)
            return request
        }
        self.kf.setImage(with: url, placeholder: placeHolderImage, options: [.requestModifier(modifier), .forceRefresh])
    }
}
