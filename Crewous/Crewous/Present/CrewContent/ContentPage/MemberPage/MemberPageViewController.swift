//
//  MemberPageViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class MemberPageViewController: BaseViewController<MemberPageView> {
    
    let viewModel = MemberPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func bind() {
        
        viewModel.data
            .bind(with: self) { owner, data in
                // data.likes2
            }.disposed(by: disposeBag)
    }
}
