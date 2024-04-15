//
//  WithoutCrewView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit

class WithoutCrewView: BaseView {

    let descriptionLabel = UILabel()
    let makeCrewButton = UIButton()
    
    override func configureHierarchy() {
        
        [descriptionLabel, makeCrewButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.leading.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(30)
            $0.trailing.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        makeCrewButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(30)
            $0.trailing.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        
        descriptionLabel.custom(title: "등록된 팀이 없습니다.", color: .white, fontScale: .regular, fontSize: .medium)
        
        makeCrewButton.custom(title: "MAKE CREW", titleColor: .black, bgColor: .customGreen)
    }

}
