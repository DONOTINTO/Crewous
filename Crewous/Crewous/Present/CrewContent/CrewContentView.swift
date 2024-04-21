//
//  CrewContentView.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import SnapKit

class CrewContentView: BaseView {
    
    let contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CrewContentCompositional.create())
    
    let containerView = UIView()
    
    override func configureHierarchy() {
        
        [contentCollectionView, containerView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(30)
        }
        
        containerView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(contentCollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(self)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        contentCollectionView.backgroundColor = .customBlack
    }
}
