//
//  StatsView.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import UIKit
import SnapKit

final class StatsView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HotCrewCompositional.create())
    
    let profileView = UIView()
    private let profileImageView = UIImageView()
    private let profileEditLabel = UILabel()
    private let nickLabel = UILabel()
    private let crewLabel = UILabel()
    private let lineView = UIView()
    
    private let heightLiteralLabel = UILabel()
    private let heightInfoLabel = UILabel()
    private let crewLiteralLabel = UILabel()
    private let crewInfoLabel = UILabel()
    private let weightLiteralLabel = UILabel()
    private let weightInfoLabel = UILabel()
    private let positionLiteralLabel = UILabel()
    private let positionInfoLabel = UILabel()
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    override func configureHierarchy() {
        
        addSubview(indicator)
        
        [profileView, nickLabel, crewLabel, lineView].forEach { addSubview($0) }
        
        [profileImageView, profileEditLabel].forEach { profileView.addSubview($0) }
        
        [heightLiteralLabel, heightInfoLabel, crewLiteralLabel, crewInfoLabel, weightLiteralLabel, weightInfoLabel, positionLiteralLabel, positionInfoLabel].forEach { addSubview($0) }
        
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.width.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalTo(profileView)
        }
        
        profileEditLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileView)
            $0.horizontalEdges.equalTo(profileView)
            $0.height.equalTo(15)
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
        
        collectionView.snp.makeConstraints {
            
            $0.top.equalTo(positionInfoLabel.snp.bottom).offset(50)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 25
        profileView.isUserInteractionEnabled = true
        
        profileEditLabel.custom(title: "edit", color: .white, fontSize: 15)
        profileEditLabel.backgroundColor = .customBlack.withAlphaComponent(0.5)
        profileEditLabel.textAlignment = .center
        
        let image = UIImage.profile
        profileImageView.image = image
        profileImageView.backgroundColor = .clear
        
        nickLabel.custom(title: "-", color: .customGray, fontScale: .bold, fontSize: .large)
        crewLabel.custom(title: "Crew -", color: .customGray, fontScale: .bold, fontSize: .large)
        lineView.backgroundColor = .customGray
        
        // STATS
        heightLiteralLabel.custom(title: "HEIGHT", color: .customGray, fontScale: .bold, fontSize: .small)
        heightInfoLabel.custom(title: "-", color: .customBlack, fontScale: .bold, fontSize: .large)
        
        crewLiteralLabel.custom(title: "CREW", color: .customGray, fontScale: .bold, fontSize: .small)
        crewInfoLabel.custom(title: "-", color: .customBlack, fontScale: .bold, fontSize: .large)
        
        weightLiteralLabel.custom(title: "WEIGHT", color: .customGray, fontScale: .bold, fontSize: .small)
        weightInfoLabel.custom(title: "-", color: .customBlack, fontScale: .bold, fontSize: .large)
        
        positionLiteralLabel.custom(title: "POSITION", color: .customGray, fontScale: .bold, fontSize: .small)
        positionInfoLabel.custom(title: "-", color: .customBlack, fontScale: .bold, fontSize: .large)
        
        indicator.hidesWhenStopped = true
        
        collectionView.backgroundColor = .customGreen.withAlphaComponent(0.1)
    }
    
    func configure(fetchSelfData: FetchUserDataModel, fetchMyCrewData: FetchMyCrewDataModel) {
        
        let mappingData: [String] = fetchSelfData.nick.split(separator: "/").map { String($0) }
        let nick = mappingData[0]
        let height = mappingData[1]
        let weight = mappingData[2]
        let position = mappingData[3]
        
        nickLabel.text = nick
        heightInfoLabel.text = "\(height)CM"
        weightInfoLabel.text = "\(weight)KG"
        positionInfoLabel.text = position
    
        guard let crewData = fetchMyCrewData.data.first,
              let crewName = crewData.crewName else { return }
        
        crewLabel.text = "Crew - \(crewName)"
        crewInfoLabel.text = crewName
        
        if let image = fetchSelfData.profileImage {
           profileImageView.loadImage(from: image)
        }
    }
    
    func updateProfileImage(image: String) {
        
        profileImageView.loadImage(from: image)
    }
    
    func indicatorStatus(isStart: Bool) {
        
        indicator.isHidden = !isStart
        isStart ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func profileViewAddTapGesture(_ gesture: UITapGestureRecognizer) {
        
        profileView.addGestureRecognizer(gesture)
    }
}
