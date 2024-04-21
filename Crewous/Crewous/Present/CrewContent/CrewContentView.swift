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
    
    let containerScrollView = UIScrollView()
    let containerView = UIView()
    
    override func configureHierarchy() {
        
        [contentCollectionView, containerScrollView].forEach { addSubview($0) }
        
        containerScrollView.addSubview(containerView)
    }
    
    override func configureLayout() {
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(30)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(contentCollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(self)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalTo(containerScrollView.contentLayoutGuide)
            $0.width.equalTo(containerScrollView.frameLayoutGuide)
            $0.height.equalTo(UIScreen.main.bounds.height)
        }
    }
    
    override func configureView() {
        
        
    }
}
