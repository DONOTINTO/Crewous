//
//  SettingTableHeaderView.swift
//  Crewous
//
//  Created by 이중엽 on 5/2/24.
//

import UIKit
import SnapKit

class SettingTableHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(10)
        }
        
        titleLabel.custom(title: "Title", color: .customGray, fontScale: .semiBold, fontSize: .small)
    }
}
