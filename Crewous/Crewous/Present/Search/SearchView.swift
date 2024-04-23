//
//  SearchView.swift
//  Crewous
//
//  Created by 이중엽 on 4/23/24.
//

import UIKit

class SearchView: BaseView {

    let searchController = UISearchController(searchResultsController: SearchResultViewController())
    
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }

    override func configureView() {
        
        searchController.searchBar.backgroundColor = .customBlack
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchBarStyle = .default
    }

}
