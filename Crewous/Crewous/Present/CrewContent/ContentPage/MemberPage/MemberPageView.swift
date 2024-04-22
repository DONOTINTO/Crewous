//
//  MemberPageView.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import SnapKit

class MemberPageView: BaseView {
    
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
        tableView.backgroundColor = .clear
    }

}
