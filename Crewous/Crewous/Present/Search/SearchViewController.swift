//
//  SearchViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController<SearchView> {
    
    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    override func bind() {
        
        let input = SearchViewModel.Input(searchButtonClickedObservable: layoutView.searchController.searchBar.rx.searchButtonClicked.asObservable())
        let output = viewModel.transform(input: input)
    }
    
    override func configureNavigation() {
        
        navigationItem.searchController = layoutView.searchController
    }

}
// let results = searchBar.rx.text.orEmpty
//     .asDriver()
//     .throttle(.milliseconds(300))
//     .distinctUntilChanged()
//     .flatMapLatest { query in
//         API.getSearchResults(query)
//             .retry(3)
//             .retryOnBecomesReachable([], reachabilityService: Dependencies.sharedDependencies.reachabilityService)
//             .startWith([]) // clears results on new search term
//             .asDriver(onErrorJustReturn: [])
//     }
//     .map { results in
//         results.map(SearchResultViewModel.init)
//     }
// 
// results
//     .drive(resultsTableView.rx.items(cellIdentifier: "WikipediaSearchCell", cellType: WikipediaSearchCell.self)) { (_, viewModel, cell) in
//         cell.viewModel = viewModel
//     }
//     .disposed(by: disposeBag)
// 
// results
//     .map { $0.count != 0 }
//     .drive(self.emptyView.rx.isHidden)
//     .disposed(by: disposeBag)
