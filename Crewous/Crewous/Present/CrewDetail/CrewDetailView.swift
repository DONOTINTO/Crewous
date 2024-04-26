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
    let menuStackView = UIStackView()
    
    let detailButton = UIButton()
    let applyButton = UIButton()
    let commentButton = UIButton()

    override func configureHierarchy() {
        
        [imageView, menuStackView].forEach { addSubview($0) }
        
        [detailButton, commentButton, applyButton].forEach {
            menuStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        menuStackView.snp.makeConstraints {
            $0.top.leading.equalTo(imageView.safeAreaLayoutGuide).inset(10)
            // $0.trailing.greaterThanOrEqualTo(imageView.safeAreaLayoutGuide).inset(30)
        }
        
        detailButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 4)
            $0.height.equalTo(40)
        }
        
        applyButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 4)
            $0.height.equalTo(40)
        }
        
        commentButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 4)
            $0.height.equalTo(40)
        }
    }
    
    override func configureView() {
        
        menuStackView.axis = .horizontal
        menuStackView.spacing = 10
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        applyButton.custom(title: "APPLY", titleColor: .white, bgColor: .customGreen)
        detailButton.custom(title: "DETAIL", titleColor: .white, bgColor: .customBlack)
        commentButton.custom(title: "COMMENT", titleColor: .white, bgColor: .customBlack)
    }
    
    func configure(_ data: PostData) {
        
        let imageData = data.files[0]
        let imageURL = URL(string: "http://lslp.sesac.kr:31222/v1/" + imageData)!
        imageView.loadImage(from: imageURL)
    }
}
