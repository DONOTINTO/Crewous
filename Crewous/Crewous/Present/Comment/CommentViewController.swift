//
//  CommentViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CommentViewController: BaseViewController<CommentView> {
    
    let viewModel = CommentViewModel()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<CommentSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let itemDeleteObservable = PublishRelay<String>()
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
        
            let userID = dataSource[indexPath].creator.userID
            
            return userID == UDManager.userID ? true : false
        }
        
        layoutView.commentTableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                
                let commentID = owner.dataSource[indexPath].commentID
                
                itemDeleteObservable.accept(commentID)
                
            }.disposed(by: disposeBag)
        
        let commentObservable = layoutView.inputButton.rx.tap
            .withLatestFrom(layoutView.userInputTextField.rx.text.orEmpty.asObservable())
        
        let input = CommentViewModel.Input(postIdentifier: PublishRelay<String>(),
                                           commentInputObservable: commentObservable, 
                                           itemDeleteObservable: itemDeleteObservable)
        let output = viewModel.transform(input: input)
        
        input.postIdentifier.accept(viewModel.postIdentifier)
        
        output.postDataSuccess
            .bind(to: layoutView.commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.postDataFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .fetchPost)
            }.disposed(by: disposeBag)
        
        output.commentSuccess
            .bind(with: self) { owner, lastIndexRow in
                
                let lastIndex = IndexPath(row: lastIndexRow - 1, section: 0)
                owner.layoutView.commentTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
                
            }.disposed(by: disposeBag)
    }
    
    override func configure() {
        
        layoutView.commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        layoutView.commentTableView.separatorStyle = .none
        
        dataSource = RxTableViewSectionedReloadDataSource<CommentSection> { dataSource, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            
            cell.configure(item)
            self.layoutView.userInputTextField.text = ""
            
            return cell
        }
    }
    
    override func configureNavigation() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.navigationController?.isToolbarHidden = true
    }
    
}
