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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func bind() {
        super.bind()
        
        self.rx.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.configureEmbedded()
            }.disposed(by: disposeBag)
    }
    
    func configureEmbedded() {
        
        let isJoinedCrew = UDManager.isJoinedCrew
        
        if isJoinedCrew {
            let vc = WithCrewViewController()
            
            self.addChild(vc)
            layoutView.containerView.addSubview(vc.layoutView)
            
            vc.layoutView.frame = layoutView.containerView.bounds
            vc.layoutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            vc.didMove(toParent: self)
        } else {
            let vc = WithoutCrewViewController()
            
            self.addChild(vc)
            layoutView.containerView.addSubview(vc.layoutView)
            
            vc.layoutView.frame = layoutView.containerView.bounds
            vc.layoutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            vc.didMove(toParent: self)
        }
    }
}
