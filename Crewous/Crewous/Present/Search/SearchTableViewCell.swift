//
//  SearchTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/24/24.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    let crewImageView = UIImageView()
    let crewLabel = UILabel()
    let blurLayoutView = UIVisualEffectView()
    let detailButton = UIButton()
    let applyButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureLayout() {
        
        [crewImageView, crewLabel, blurLayoutView, detailButton, applyButton].forEach { contentView.addSubview($0) }
     
        crewImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(crewImageView.snp.width)
        }
        
        blurLayoutView.snp.makeConstraints {
            $0.bottom.equalTo(crewImageView).inset(10)
            $0.height.equalTo(60)
            $0.horizontalEdges.equalTo(crewImageView).inset(15)
        }
        
        detailButton.snp.makeConstraints {
            $0.leading.equalTo(blurLayoutView).inset(10)
            $0.trailing.equalTo(blurLayoutView.snp.centerX).inset(10)
            $0.height.equalTo(40)
            $0.bottom.equalTo(blurLayoutView).inset(10)
        }
        
        applyButton.snp.makeConstraints {
            $0.leading.equalTo(blurLayoutView.snp.centerX).offset(10)
            $0.trailing.equalTo(blurLayoutView).inset(10)
            $0.height.equalTo(40)
            $0.bottom.equalTo(blurLayoutView).inset(10)
        }
        
        crewLabel.snp.makeConstraints {
            $0.top.equalTo(crewImageView.snp.bottom)
            $0.horizontalEdges.equalTo(crewImageView)
        }
    }
    

    func configureView() {
        
        contentView.backgroundColor = .customBlack
        
        crewImageView.contentMode = .scaleAspectFill
        crewImageView.layer.cornerRadius = 10
        crewImageView.layer.masksToBounds = true
        
        crewLabel.font = FontManager.getFont(scale: .bold, size: .medium)
        crewLabel.textColor = .white
        
        blurLayoutView.backgroundColor = .customGray.withAlphaComponent(0.1)
        blurLayoutView.effect = UIBlurEffect(style: .dark)
        blurLayoutView.layer.cornerRadius = 10
        blurLayoutView.layer.masksToBounds = true
        
        detailButton.custom(title: "SHOW DETAIL", titleColor: .white, bgColor: .customGray.withAlphaComponent(0.2))
        detailButton.configuration?.attributedTitle?.font = FontManager.getFont(scale: .bold, size: .small)
        applyButton.custom(title: "APPLY", titleColor: .black, bgColor: .customGreen)
        applyButton.configuration?.attributedTitle?.font = FontManager.getFont(scale: .bold, size: .small)
        
    }
    
    func configure(_ data: PostData) {
        
        guard let crewName = data.crewName else { return }
        
        let imageData = data.files[0]
        let imageURL = URL(string: "http://lslp.sesac.kr:31222/v1/" + imageData)!
        crewImageView.loadImage(from: imageURL)
        
        crewLabel.text = "@" + crewName
    }
}
