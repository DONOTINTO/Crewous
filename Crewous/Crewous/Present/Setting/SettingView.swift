//
//  SettingView.swift
//  Crewous
//
//  Created by 이중엽 on 4/29/24.
//

import UIKit
import SnapKit

class SettingView: BaseView {

    let tableView = UITableView()
    
    override func configureHierarchy() {
        
        addSubview(tableView)
    }

    override func configureLayout() {
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
    }
}
