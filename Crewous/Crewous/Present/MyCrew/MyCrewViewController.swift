//
//  MyCrewViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit

class MyCrewViewController: BaseViewController<MyCrewView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureEmbedded()
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
    
    override func configureNavigation() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
