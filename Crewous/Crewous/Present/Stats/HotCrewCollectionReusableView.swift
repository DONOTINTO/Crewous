//
//  HotCrewCollectionReusableView.swift
//  Crewous
//
//  Created by 이중엽 on 5/2/24.
//

import UIKit
import SnapKit

class HotCrewCollectionReusableView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func configureView() {
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(self).inset(10)
        }
    }
    
    func configure(_ title: String) {
        
        titleLabel.custom(title: title, color: .customBlack, fontScale: .bold, fontSize: .regular)
    }
}
