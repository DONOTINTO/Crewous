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
        
        // CrewContent VC 띄우기
        layoutView.detailButton.rx.tap.bind(with: self) { owner, _ in
            
            guard let postData = owner.viewModel.postData,
                  let userData = owner.viewModel.userData else { return }
            
            let nextVC = CrewContentViewController()
            let fraction = UISheetPresentationController.Detent.custom { _ in 300 }
            nextVC.sheetPresentationController?.detents = [fraction, .medium(), .large()]
            nextVC.sheetPresentationController?.prefersGrabberVisible = true
            nextVC.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
            
            self.present(nextVC, animated: true) {
                nextVC.viewModel.postData.accept(postData)
                nextVC.viewModel.userData.accept(userData)
            }
            
        }.disposed(by: disposeBag)
        
        
        
        
        
        let input = CrewDetailViewModel.Input(postIdentifierObservable: viewModel.postIdentifier)
        let output = viewModel.transform(input: input)
        
        // Crew Content VC Embedded
        Observable.zip(output.postDataSuccess, output.userDataSuccess)
            .bind(with: self) { owner, data in
                
                let (postData, userData) = data
                
                owner.layoutView.configure(postData)
                
                let nextVC = CrewContentViewController()
                let fraction = UISheetPresentationController.Detent.custom { _ in 300 }
                nextVC.sheetPresentationController?.detents = [fraction, .medium(), .large()]
                nextVC.sheetPresentationController?.prefersGrabberVisible = true
                nextVC.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
                
                self.present(nextVC, animated: true) {
                    nextVC.viewModel.postData.accept(postData)
                    nextVC.viewModel.userData.accept(userData)
                }
                
            }.disposed(by: disposeBag)
        
        output.postDataFailure
            .bind(with: self) { owner, apiError in
                self.errorHandler(apiError, calltype: .fetchPost)
            }.disposed(by: disposeBag)
    }
}
