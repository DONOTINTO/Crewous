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
    
    let searchTableView = UITableView()
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    
    
    override func configureHierarchy() {
        
        [emptyImageView, emptyLabel, searchTableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        searchTableView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.height.width.equalTo(200)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(self).inset(10)
        }
    }

    override func configureView() {
        
        searchTableView.backgroundColor = .clear
        searchTableView.separatorStyle = .none
        
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.autocapitalizationType = .none
        
        emptyImageView.image = UIImage.ball
        
        emptyLabel.custom(title: "THERE IS NO SEARCH RESULT", color: .customGray.withAlphaComponent(0.5), fontScale: .bold, fontSize: .medium)
        emptyLabel.textAlignment = .center
    }

}
