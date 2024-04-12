//
//  SignUpViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController<SignUpView> {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
        // MARK: Tap Gesture
        let tapGesture = UITapGestureRecognizer()
        layoutView.scrollView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.subscribe(with: self) { owner, _ in
            
            owner.layoutView.scrollView.endEditing(true)
        }.disposed(by: disposeBag)
        
    }
}
