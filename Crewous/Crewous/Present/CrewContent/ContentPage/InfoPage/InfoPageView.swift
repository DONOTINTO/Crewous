//
//  InfoPageView.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import SnapKit

class InfoPageView: BaseView {
    
    let tableView = UITableView()

    override func configureHierarchy() {
        
        addSubview(tableView)
    }

    override func configureLayout() {
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    override func configureView() {
    
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
}
