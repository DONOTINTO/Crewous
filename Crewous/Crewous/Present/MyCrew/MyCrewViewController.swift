//
//  MyCrewViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

class MyCrewViewController: BaseViewController<MyCrewView> {
    
    let viewModel = MyCrewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func bind() {
        
        let input = MyCrewViewModel.Input(viewWillAppearObservable: self.rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        // 크루 정보 체크 성공
        output.fetchCrewSuccess
            .bind(with: self) { owner, fetchCrewData in
                
                guard let crewData = fetchCrewData.data.first else {
                    owner.configureEmbedded(nil)
                    return
                }
                
                owner.configureEmbedded(crewData)
                
            }.disposed(by: disposeBag)
        
        // 크루 정보 체크 실패
        output.fetchFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .fetchSelf)
            }.disposed(by: disposeBag)
        
    }
    
    func configureEmbedded(_ crewData: PostData?) {
        
        if let crewData {
            let vc = CrewDetailViewController()
            
            self.addChild(vc)
            layoutView.containerView.addSubview(vc.layoutView)
            
            vc.layoutView.frame = layoutView.containerView.bounds
            vc.layoutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vc.viewModel.postIdentifier.accept(crewData.postID)
            
            vc.didMove(toParent: self)
        } else {
            let vc = WithoutCrewViewController()
            
            self.addChild(vc)
            layoutView.containerView.addSubview(vc.layoutView)
            
            vc.layoutView.frame = layoutView.bounds
            vc.layoutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            vc.didMove(toParent: self)
        }
    }
}
