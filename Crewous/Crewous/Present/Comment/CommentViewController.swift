//
//  CommentViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: BaseViewController<CommentView> {

    let viewModel = CommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let commentObservable = Observable.combineLatest(layoutView.userInputTextField.rx.controlEvent(.editingDidEndOnExit),
                                                         layoutView.inputButton.rx.tap)
            .withLatestFrom(layoutView.userInputTextField.rx.text.orEmpty.asObservable())
        
        let input = CommentViewModel.Input(postIdentifier: PublishRelay<String>(),
                                       commentInputObservable: commentObservable)
        let output = viewModel.transform(input: input)
        
        input.postIdentifier.accept(viewModel.postIdentifier)
        
        output.postDataSuccess
            .bind(to: layoutView.commentTableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { index, data, cell in
                
                cell.configure(data)
            }.disposed(by: disposeBag)
        
        output.postDataFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .fetchPost)
            }.disposed(by: disposeBag)
    }
    
    override func configure() {
        
        layoutView.commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        layoutView.commentTableView.separatorStyle = .none
    }
    
    override func configureNavigation() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.navigationController?.isToolbarHidden = true
    }

}
