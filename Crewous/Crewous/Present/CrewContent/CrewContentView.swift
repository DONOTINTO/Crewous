//
//  CrewContentView.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import SnapKit

class CrewContentView: BaseView {
    
    let profileImageView = UIImageView()
    let crewLabel = UILabel()
    let leaderLabel = UILabel()
    
    let introduceScrollView = UIScrollView()
    let contentView = UIView()
    let introduceLabel = UILabel()
    
    let contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CrewContentCompositional.create())
    
    let containerView = UIView()
    
    override func configureHierarchy() {
        
        [profileImageView, crewLabel, leaderLabel, introduceScrollView].forEach { addSubview($0) }
        [contentCollectionView, containerView].forEach { addSubview($0) }
        
        introduceScrollView.addSubview(contentView)
        contentView.addSubview(introduceLabel)
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self).inset(10)
            $0.leading.equalTo(self).inset(10)
            $0.height.width.equalTo(40)
        }
        
        crewLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(self).inset(30)
            $0.height.equalTo(25)
        }
        
        leaderLabel.snp.makeConstraints {
            $0.top.equalTo(crewLabel.snp.bottom)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(self).inset(30)
            $0.height.equalTo(15)
        }
        
        introduceScrollView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(80)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(introduceScrollView.contentLayoutGuide)
            $0.width.equalTo(introduceScrollView.frameLayoutGuide)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(10)
        }
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(introduceScrollView.snp.bottom).inset(10)
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
        
        contentCollectionView.backgroundColor = .white
        
        let image = UIImage.profile
        profileImageView.image = image
        profileImageView.backgroundColor = .clear
        
        crewLabel.custom(title: "-", color: .customBlack, fontScale: .bold, fontSize: .large)
        leaderLabel.custom(title: "Crew -", color: .customGray, fontScale: .bold, fontSize: .medium)
        
        introduceLabel.custom(title: "", color: .customBlack, fontScale: .semiBold, fontSize: .small)
        introduceLabel.textAlignment = .left
        introduceLabel.numberOfLines = 0
    }
    
    func configure(_ data: PostData) {
        
        introduceLabel.text = data.introduce
        crewLabel.text = data.crewName
        
        let nick = data.creator.nick.split(separator: "/")[0]
        leaderLabel.text = String(nick)
    }
}
