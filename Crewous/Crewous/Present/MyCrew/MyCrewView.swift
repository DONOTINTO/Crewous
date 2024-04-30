//
//  MyCrewView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit

final class MyCrewView: BaseView {
    
    let containerView = UIView()
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override func configureHierarchy() {
        
        [containerView, indicator].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        indicator.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
     
        indicator.hidesWhenStopped = true
    }
}
