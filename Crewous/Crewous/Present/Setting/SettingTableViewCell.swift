//
//  SettingTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 5/2/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(10)
        }
        
        titleLabel.custom(title: "123", color: .customBlack, fontScale: .regular, fontSize: .medium)
    }

}
