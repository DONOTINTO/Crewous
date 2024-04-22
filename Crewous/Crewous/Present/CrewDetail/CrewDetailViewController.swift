//
//  CrewDetailViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

class CrewDetailViewController: BaseViewController<CrewDetailView> {
    
    let viewModel = CrewDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = CrewDetailViewModel.Input(postIdentifierObservable: viewModel.postIdentifier)
        let output = viewModel.transform(input: input)
        
        // Crew Content VC Embedded
        Observable.zip(output.postDataSuccess, output.userDataSuccess)
            .bind(with: self) { owner, data in
                
                let (postData, userData) = data
                
                owner.layoutView.configure(postData)
                
                let crewContentVC = CrewContentViewController()
                
                self.addChild(crewContentVC)
                owner.layoutView.containerView.addSubview(crewContentVC.layoutView)
                
                crewContentVC.layoutView.frame = owner.layoutView.containerView.bounds
                crewContentVC.layoutView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
                // PostData / userData 전달
                crewContentVC.viewModel.postData.accept(postData)
                crewContentVC.viewModel.userData.accept(userData)
                
                crewContentVC.didMove(toParent: self)
                
            }.disposed(by: disposeBag)
        
        output.postDataFailure
            .bind(with: self) { owner, apiError in
                self.errorHandler(apiError, calltype: .fetchPost)
            }.disposed(by: disposeBag)
    }
}
