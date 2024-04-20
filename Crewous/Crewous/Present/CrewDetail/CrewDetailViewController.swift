//
//  CrewDetailViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit

class CrewDetailViewController: BaseViewController<CrewDetailView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedded()
    }
    
    func embedded() {
        
        let crewContentVC = CrewContentViewController()
        self.addChild(crewContentVC)
        layoutView.containerView.addSubview(crewContentVC.layoutView)
        
        crewContentVC.layoutView.frame = layoutView.containerView.bounds
        crewContentVC.layoutView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        crewContentVC.didMove(toParent: self)
    }
}
