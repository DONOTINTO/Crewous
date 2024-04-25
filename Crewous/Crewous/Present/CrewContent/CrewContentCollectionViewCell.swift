//
//  CrewContentCollectionViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import SnapKit

class CrewContentCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
        
        [titleLabel, lineView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        lineView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(contentView)
            $0.height.equalTo(2)
        }
    }
    
    func configureView() {
        
        titleLabel.custom(title: "TEST", color: .customBlack, fontScale: .semiBold, fontSize: .medium)
        titleLabel.textAlignment = .center
        
        lineView.backgroundColor = .customBlack
    }
    
    func configure(isSelected: Bool) {
        
        titleLabel.textColor = isSelected ? .customBlack : .customGray
        
        lineView.isHidden = !isSelected
    }
}
