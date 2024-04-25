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
        
        let input = SearchViewModel.Input(searchButtonClickedObservable: layoutView.searchController.searchBar.rx.searchButtonClicked.asObservable(),
                                          searchTextObservable: layoutView.searchController.searchBar.rx.text.orEmpty.asObservable())
        let output = viewModel.transform(input: input)
        
        output.searchResultObservable
            .bind(to: layoutView.searchTableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { [weak self] index, data, cell in
                
                guard let self else { return }
                
                cell.configure(data)
                
                // Crew Detail 뷰 켜기 -> Post ID 넘겨줘야 함
                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        
                        let nextVC = CrewDetailViewController()
                        nextVC.sheetPresentationController?.detents = [.medium(), .large()]
                        
                        self.present(nextVC, animated: true) {
                            nextVC.viewModel.postIdentifier.accept(data.postID)
                        }
                        
                    }.disposed(by: cell.disposeBag)
                
                
                // Like2 적용하기
                cell.applyButton.rx.tap
                    .bind(with: self) { owner, _ in
                        
                    }.disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
        output.searchResultEmptyObservable
            .bind(with: self) { owner, isExist in
                
                owner.layoutView.emptyImageView.isHidden = !isExist
                owner.layoutView.emptyLabel.isHidden = !isExist
            }.disposed(by: disposeBag)
    }
    
    override func configure() {
        
        layoutView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    override func configureNavigation() {
        
        navigationItem.searchController = layoutView.searchController
    }

}
