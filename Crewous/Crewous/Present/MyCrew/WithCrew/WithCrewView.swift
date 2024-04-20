//
//  WithCrewView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit
import Kingfisher

class WithCrewView: BaseView {
    
    let profileImageView = UIImageView()
    let crewLabel = UILabel()
    let leaderLabel = UILabel()
    
    let imageView = UIImageView()

    override func configureHierarchy() {
        
        [profileImageView, crewLabel, leaderLabel, imageView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        let ratio = (UIScreen.main.bounds.width / 5) * 3
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self).inset(20)
            $0.leading.equalTo(self).inset(30)
            $0.height.width.equalTo(30)
        }
        
        crewLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(-3)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(self).inset(30)
            $0.height.equalTo(20)
        }
        
        leaderLabel.snp.makeConstraints {
            $0.top.equalTo(crewLabel.snp.bottom)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(15)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(ratio)
        }
    }
    
    override func configureView() {
        
        let image = UIImage.profile
        profileImageView.image = image
        profileImageView.backgroundColor = .clear
        
        crewLabel.custom(title: "-", color: .white, fontScale: .bold, fontSize: .medium)
        leaderLabel.custom(title: "Crew -", color: .customGray, fontScale: .bold, fontSize: .small)
    }
    
    func configure(_ data: PostData) {
        crewLabel.text = data.title
        
        let nick = data.creator.nick.split(separator: "/")[0]
        leaderLabel.text = String(nick)
        
        let imageData = data.files[0]
        let imageURL = URL(string: "http://lslp.sesac.kr:31222/v1/" + imageData)!
        imageView.loadImage(from: imageURL)
    }
}
