//
//  MemberPageTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import UIKit
import SnapKit

class MemberPageTableViewCell: UITableViewCell {

    let profileImageView = UIImageView()
    let nickLabel = UILabel()
    let positionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
     
        [profileImageView, nickLabel, positionLabel].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalTo(contentView).inset(5)
            $0.height.width.equalTo(30)
        }
        
        nickLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        positionLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(5)
            $0.leading.greaterThanOrEqualTo(nickLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(contentView).inset(20)
        }
    }
    

    func configureView() {
        
        let image = UIImage.profile
        profileImageView.image = image
        nickLabel.custom(title: "", color: .white, fontScale: .regular, fontSize: .regular)
        positionLabel.custom(title: "", color: .white, fontScale: .regular, fontSize: .regular)
    }
    
    func configure(nick: String, position: String) {
        
        nickLabel.text = nick
        positionLabel.text = position
    }

}
