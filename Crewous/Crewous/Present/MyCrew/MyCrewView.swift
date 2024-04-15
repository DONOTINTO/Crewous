//
//  MyCrewView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit

class MyCrewView: BaseView {
    
    let myCrewLiteralLabel = UILabel()
    let containerView = UIView()
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override func configureHierarchy() {
        
        [myCrewLiteralLabel, indicator, containerView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        myCrewLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(indicator.snp.leading)
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(myCrewLiteralLabel.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self)
        }
    }
    
    override func configureView() {
     
        myCrewLiteralLabel.custom(title: "My Crew", color: .white, fontScale: .bold, fontSize: .large)
        indicator.hidesWhenStopped = true
    }
}
