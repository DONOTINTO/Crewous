//
//  CrewDetailView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CrewDetailView: BaseView {
    
    private let imageView = UIImageView()
    private let menuStackView = UIStackView()
    private let crewLayerView = UIView()
    private let crewLabel = UILabel()
    
    let detailButton = UIButton()
    let applyButton = UIButton()
    let commentButton = UIButton()
    let resignButton = UIButton()

    override func configureHierarchy() {
        
        [imageView, menuStackView, resignButton, crewLayerView, crewLabel].forEach { addSubview($0) }
        
        [detailButton, commentButton, applyButton, resignButton].forEach {
            menuStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        menuStackView.snp.makeConstraints {
            $0.top.leading.equalTo(imageView.safeAreaLayoutGuide).inset(10)
        }
        
        crewLayerView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(imageView)
            $0.height.equalTo(50)
        }
        
        crewLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(crewLayerView).inset(10)
            $0.centerY.equalTo(crewLayerView)
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
        
        resignButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 4)
            $0.height.equalTo(40)
        }
    }
    
    override func configureView() {
        
        menuStackView.axis = .horizontal
        menuStackView.spacing = 10
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        crewLayerView.backgroundColor = .customBlack.withAlphaComponent(0.5)
        
        applyButton.custom(title: "APPLY", titleColor: .white, bgColor: .customGreen)
        detailButton.custom(title: "DETAIL", titleColor: .white, bgColor: .customBlack)
        commentButton.custom(title: "COMMENT", titleColor: .white, bgColor: .customBlack)
        resignButton.custom(title: "RESIGN", titleColor: .white, bgColor: .systemRed)
    }
    
    func configure(_ data: PostData) {
        
        guard let crewName = data.crewName,
              let imageData = data.files.first else { return }
        
        imageView.loadImage(from: imageData)
        
        crewLabel.custom(title: crewName, color: .white, fontScale: .bold, fontSize: .large)
    }
    
    func setApplyButton(isHidden: Bool) {
        
        applyButton.isHidden = isHidden
    }
    
    func setResignButton(isHidden: Bool) {
        
        resignButton.isHidden = isHidden
    }
}
