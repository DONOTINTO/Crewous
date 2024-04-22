//
//  StatsView.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import UIKit
import SnapKit

class StatsView: BaseView {
    
    let profileImageView = UIImageView()
    let nickLabel = UILabel()
    let crewLabel = UILabel()
    let lineView = UIView()
    
    let heightLiteralLabel = UILabel()
    let heightInfoLabel = UILabel()
    let crewLiteralLabel = UILabel()
    let crewInfoLabel = UILabel()
    let weightLiteralLabel = UILabel()
    let weightInfoLabel = UILabel()
    let positionLiteralLabel = UILabel()
    let positionInfoLabel = UILabel()
    
    
    let withDrawButton =  UIButton()
    let logoutButton = UIButton()
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override func configureHierarchy() {
        
        addSubview(indicator)
        
        [profileImageView, nickLabel, crewLabel, lineView].forEach { addSubview($0) }
        
        [heightLiteralLabel, heightInfoLabel, crewLiteralLabel, crewInfoLabel, weightLiteralLabel, weightInfoLabel, positionLiteralLabel, positionInfoLabel].forEach { addSubview($0) }
        
#if DEBUG
        debug()
#endif
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.width.equalTo(50)
        }
        
        nickLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(indicator.snp.leading)
            $0.height.equalTo(25)
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        crewLabel.snp.makeConstraints {
            $0.top.equalTo(nickLabel.snp.bottom).offset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(14)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(crewLabel.snp.bottom).offset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(1)
            $0.bottom.equalTo(profileImageView)
        }
        
        // STATS
        heightLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(40)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(self.snp.centerX)
        }
        
        heightInfoLabel.snp.makeConstraints {
            $0.top.equalTo(heightLiteralLabel.snp.bottom).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(self.snp.centerX)
        }
        
        crewLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(40)
            $0.leading.equalTo(self.snp.centerX)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        crewInfoLabel.snp.makeConstraints {
            $0.top.equalTo(heightLiteralLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.snp.centerX)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        weightLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(heightLiteralLabel.snp.bottom).offset(90)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(self.snp.centerX)
        }
        
        weightInfoLabel.snp.makeConstraints {
            $0.top.equalTo(weightLiteralLabel.snp.bottom).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(self.snp.centerX)
        }
        
        positionLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(crewLiteralLabel.snp.bottom).offset(90)
            $0.leading.equalTo(self.snp.centerX)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        positionInfoLabel.snp.makeConstraints {
            $0.top.equalTo(positionLiteralLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.snp.centerX)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func configureView() {
        
        let image = UIImage.profile
        profileImageView.image = image
        profileImageView.backgroundColor = .clear
        
        nickLabel.custom(title: "-", color: .customGray, fontScale: .bold, fontSize: .large)
        crewLabel.custom(title: "Crew -", color: .customGray, fontScale: .bold, fontSize: .large)
        lineView.backgroundColor = .customGray
        
        // STATS
        heightLiteralLabel.custom(title: "HEIGHT", color: .customGray, fontScale: .bold, fontSize: .small)
        heightInfoLabel.custom(title: "-", color: .white, fontScale: .bold, fontSize: .large)
        
        crewLiteralLabel.custom(title: "CREW", color: .customGray, fontScale: .bold, fontSize: .small)
        crewInfoLabel.custom(title: "-", color: .white, fontScale: .bold, fontSize: .large)
        
        weightLiteralLabel.custom(title: "WEIGHT", color: .customGray, fontScale: .bold, fontSize: .small)
        weightInfoLabel.custom(title: "-", color: .white, fontScale: .bold, fontSize: .large)
        
        positionLiteralLabel.custom(title: "POSITION", color: .customGray, fontScale: .bold, fontSize: .small)
        positionInfoLabel.custom(title: "-", color: .white, fontScale: .bold, fontSize: .large)
        
        indicator.hidesWhenStopped = true
    }
    
    func debug() {
        
        addSubview(withDrawButton)
        addSubview(logoutButton)
        
        withDrawButton.snp.makeConstraints {
            $0.bottom.equalTo(logoutButton.snp.top).offset(-10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(30)
        }
        
        logoutButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(30)
        }
        
        withDrawButton.custom(title: "탈퇴(테스트용)", titleColor: .black, bgColor: .customGreen)
        
        logoutButton.custom(title: "로그아웃(테스트용)", titleColor: .black, bgColor: .customGreen)
    }
}
