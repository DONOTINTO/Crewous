//
//  CrewDetailViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CrewDetailViewController: BaseViewController<CrewDetailView> {
    
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
            nextVC.setDetent()
            
            owner.present(nextVC, animated: true) {
                nextVC.viewModel.postData.accept(postData)
                nextVC.viewModel.userData.accept(userData)
            }
            
        }.disposed(by: disposeBag)
        
        // Comment VC 띄우기
        layoutView.commentButton.rx.tap.bind(with: self) { owner, _ in
            
            guard let postData = owner.viewModel.postData else { return }
            
            let nextVC = CommentViewController()
            nextVC.setDetent()
            
            nextVC.viewModel.postIdentifier = postData.postID
            owner.present(nextVC, animated: true)
            
        }.disposed(by: disposeBag)
        
        // MARK: View Model
        let input = CrewDetailViewModel.Input(viewWillAppearObservable: self.rx.viewWillAppear,
                                              postIdentifierObservable: viewModel.postIdentifier,
                                              crewApplyButtonTapObservable: layoutView.applyButton.rx.tap.asObservable(), crewResignButtonTapObservable: layoutView.resignButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        // 크루 정보 및 크루원 정보 -> CrewContent VC로 전달
        Observable.zip(output.postDataSuccess, output.userDataSuccess)
            .bind(with: self) { owner, data in
                
                let (postData, userData) = data
                
                owner.layoutView.configure(postData)
                
                let nextVC = CrewContentViewController()
                nextVC.setDetent()
                
                self.present(nextVC, animated: true) {
                    nextVC.viewModel.postData.accept(postData)
                    nextVC.viewModel.userData.accept(userData)
                }
                
            }.disposed(by: disposeBag)
        
        // 크루 정보 호출 실패
        output.postDataFailure
            .bind(with: self) { owner, apiError in
                
                self.errorHandler(apiError, calltype: .fetchPost)
            }.disposed(by: disposeBag)
        
        // 내 크루 정보 호출 실패
        output.fetchSelfFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .fetchMyCrew)
            }.disposed(by: disposeBag)
        
        // 등록된 크루가 없는 경우
        output.notRegistObservable
            .bind(with: self) { owner, _ in
                
                owner.layoutView.setApplyButton(isHidden: false)
                owner.layoutView.setResignButton(isHidden: true)
                
            }.disposed(by: disposeBag)
        
        // 해당 크루와 내 크루가 동일한지 안한지
        output.isMyCrewObservable
            .bind(with: self) { owner, isMyCrew in
                
                // Apply는 무조건 숨김
                owner.layoutView.setApplyButton(isHidden: true)
                
                // Resign은 내 크루일 경우에만 노출
                owner.layoutView.setResignButton(isHidden: !isMyCrew)
                
            }.disposed(by: disposeBag)
        
        // 크루 등록
        output.applySuccess
            .bind(with: self) { owner, _ in
                
                owner.refresh()
                
            }.disposed(by: disposeBag)
        
        // 크루 탈퇴
        output.resignSuccess
            .bind(with: self) { owner, _ in
                
                guard let parent = owner.parent,
                      let parentVC = parent as? MyCrewViewController else {
                    
                    owner.refresh()
                    
                    return
                }
                
                parentVC.viewWillAppear(true)
                
            }.disposed(by: disposeBag)
        
        // 크루 가입 실패
        output.applyOrResignFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .like2)
            }.disposed(by: disposeBag)
    }
    
    private func refresh() {
        
        if let postData = viewModel.postData {
            viewModel.userData = nil
            viewModel.postData = nil
            self.viewWillAppear(true)
            viewModel.postIdentifier.accept(postData.postID)
        }
    }
}
