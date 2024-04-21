//
//  InfoPageTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import UIKit
import SnapKit

class InfoPageTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
     
        [titleLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.bottom.equalTo(contentView).inset(30)
        }
    }
    

    func configureView() {
        
        titleLabel.custom(title: "", color: .customGray, fontScale: .semiBold, fontSize: .small)
        contentLabel.custom(title: "", color: .white, fontScale: .regular, fontSize: .regular)
    }
    
    func configure(title: String, content: String) {
        
        titleLabel.text = title
        contentLabel.text = content
        contentLabel.numberOfLines = 0
    }
}
