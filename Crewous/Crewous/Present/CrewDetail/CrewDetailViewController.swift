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
        
        // Crew Content VC Embedded + PostData전달
        viewModel.data.bind(with: self) { owner, data in
            
            owner.layoutView.configure(data)
            
            let crewContentVC = CrewContentViewController()
            
            self.addChild(crewContentVC)
            owner.layoutView.containerView.addSubview(crewContentVC.layoutView)
            
            crewContentVC.layoutView.frame = owner.layoutView.containerView.bounds
            crewContentVC.layoutView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            crewContentVC.viewModel.data.accept(data)
            
            crewContentVC.didMove(toParent: self)
            
        }.disposed(by: disposeBag)
    }
}
