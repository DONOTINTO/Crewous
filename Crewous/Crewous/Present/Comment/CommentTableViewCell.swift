//
//  CommentTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CommentTableViewCell: UITableViewCell {
    
    let userProfileImageView = UIImageView()
    let nickLabel = UILabel()
    let commentLabel = UILabel()

    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bind()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind() {
        
    }

    func configureLayout() {
        
        [userProfileImageView, nickLabel, commentLabel].forEach { contentView.addSubview($0) }
     
        userProfileImageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(10)
            $0.width.height.equalTo(40)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        nickLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(10)
            $0.height.equalTo(15)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(contentView).inset(10)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(nickLabel.snp.bottom).offset(5)
            $0.height.equalTo(20)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(contentView).inset(10)
            $0.bottom.equalTo(contentView).inset(10)
        }
    }
    

    func configureView() {
        
        contentView.backgroundColor = .white
        
        userProfileImageView.image = UIImage.profile
        nickLabel.custom(title: "", color: .customGray, fontScale: .semiBold, fontSize: .tiny)
        commentLabel.custom(title: "", color: .black, fontScale: .regular, fontSize: .small)
    }
    
    func configure(_ data: CrewComment) {
        
        let nick = String(data.creator.nick.split(separator: "/")[0])
        let comment = data.content
        
        nickLabel.text = nick
        commentLabel.text = comment
        
        guard let profileImage = data.creator.profileImage else { return }
        
        let imageData = profileImage
        let imageURL = URL(string: "http://lslp.sesac.kr:31222/v1/" + imageData)!
        userProfileImageView.loadImage(from: imageURL)
    }
}
