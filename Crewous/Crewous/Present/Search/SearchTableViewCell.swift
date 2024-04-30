//
//  SearchTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchTableViewCell: UITableViewCell {
    
    let crewImageView = UIImageView()
    let crewLabel = UILabel()
    let blurLayoutView = UIVisualEffectView()
    let detailButton = UIButton()

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
        
        [crewImageView, crewLabel, blurLayoutView, detailButton].forEach { contentView.addSubview($0) }
     
        crewImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(crewImageView.snp.width)
        }
        
        blurLayoutView.snp.makeConstraints {
            $0.bottom.equalTo(crewImageView).inset(10)
            $0.height.equalTo(60)
            $0.horizontalEdges.equalTo(crewImageView).inset(15)
        }
        
        detailButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(blurLayoutView).inset(10)
            $0.height.equalTo(40)
            $0.bottom.equalTo(blurLayoutView).inset(10)
        }
        
        crewLabel.snp.makeConstraints {
            $0.top.equalTo(crewImageView.snp.bottom)
            $0.horizontalEdges.equalTo(crewImageView)
            $0.bottom.equalTo(contentView).inset(10)
        }
    }
    

    func configureView() {
        
        contentView.backgroundColor = .white
        
        crewImageView.contentMode = .scaleAspectFill
        crewImageView.layer.cornerRadius = 20
        crewImageView.layer.masksToBounds = true
        crewImageView.clipsToBounds = true
        
        crewLabel.font = FontManager.getFont(scale: .bold, size: .medium)
        crewLabel.textColor = .customBlack
        
        blurLayoutView.backgroundColor = .customGray.withAlphaComponent(0.1)
        blurLayoutView.effect = UIBlurEffect(style: .light)
        blurLayoutView.layer.cornerRadius = 10
        blurLayoutView.layer.masksToBounds = true
        
        detailButton.custom(title: "SHOW DETAIL", titleColor: .customBlack, bgColor: .white.withAlphaComponent(0.2))
        detailButton.configuration?.attributedTitle?.font = FontManager.getFont(scale: .bold, size: .small)
    }
    
    func configure(_ data: PostData) {
        
        guard let crewName = data.crewName else { return }
        
        let imageData = data.files[0]
        crewImageView.loadImage(from: imageData)
        
        crewLabel.text = "@" + crewName
    }
}
