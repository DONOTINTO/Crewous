//
//  CrewDetailView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit
import Kingfisher

class CrewDetailView: BaseView {
    
    let imageView = UIImageView()

    override func configureHierarchy() {
        
        [imageView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    override func configureView() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }
    
    func configure(_ data: PostData) {
        
        let imageData = data.files[0]
        let imageURL = URL(string: "http://lslp.sesac.kr:31222/v1/" + imageData)!
        imageView.loadImage(from: imageURL)
    }
}
