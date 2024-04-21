//
//  InfoPageViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class InfoPageViewController: BaseViewController<InfoPageView> {
    
    let viewModel = InfoPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        
        viewModel.data
            .bind(with: self) { owner, data in
                // print("info")
            }.disposed(by: disposeBag)
    }
}
