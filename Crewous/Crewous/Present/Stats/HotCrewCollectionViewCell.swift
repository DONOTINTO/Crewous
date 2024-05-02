//
//  HotCrewCollectionViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 5/2/24.
//

import UIKit
import SnapKit

class HotCrewCollectionViewCell: UICollectionViewCell {
    
    let crewImageView = UIImageView()
    let crewnameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        
        [crewImageView, crewnameLabel].forEach { contentView.addSubview($0) }
        
        crewImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalTo(contentView).inset(10)
            $0.height.width.equalTo(60)
        }
        
        crewnameLabel.snp.makeConstraints {
            $0.leading.equalTo(crewImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(contentView).inset(10)
            $0.top.equalTo(contentView).inset(10)
            $0.bottom.equalTo(contentView).inset(10)
        }
        
        crewImageView.layer.cornerRadius = 10
        crewImageView.layer.masksToBounds = true
        crewImageView.contentMode = .scaleAspectFill
        
        crewnameLabel.textAlignment = .left
        
        contentView.backgroundColor = .clear
    }
    
    func configure(_ data: PostData) {
        
        crewnameLabel.custom(title: data.crewName!, color: .customBlack, fontScale: .semiBold, fontSize: .regular)
        
        if let image = data.files.first {
            crewImageView.loadImage(from: image)
        }
    }
}
