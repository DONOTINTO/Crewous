//
//  SearchView.swift
//  Crewous
//
//  Created by 이중엽 on 4/23/24.
//

import UIKit
import SnapKit

class SearchView: BaseView {

    let searchController = UISearchController()
    
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
        tableView.separatorStyle = .none
        
        searchController.searchBar.backgroundColor = .customBlack
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.autocapitalizationType = .none
    }

}
