//
//  SignInViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController<SignInView> {

    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        // MARK: Tap Gesture
        let tapGesture = UITapGestureRecognizer()
        layoutView.createLabel.addGestureRecognizer(tapGesture)
        
        // SignUP VC로 이동
        tapGesture.rx.event.bind(with: self) { owner, _ in
            
        }.disposed(by: disposeBag)
        
        // MARK: ViewModel
        let input = SignInViewModel.Input(
            emailText: layoutView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: layoutView.passwordTextField.rx.text.orEmpty.asObservable(),
            signInButtonTap: layoutView.signInButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.signInTouchEnabled.bind(with: self) { owner, isEnabled in
            
            owner.layoutView.signInButton.isEnabled = isEnabled
        }.disposed(by: disposeBag)
        
        output.signInValidation.bind(with: self) { owner, isValid in
            
            owner.layoutView.signInButton.animate()
            owner.layoutView.signInValidLabel.isHidden = isValid
            
            // Test Code
            if isValid {
                // 다음 화면으로 넘어가기
                let testAlert = UIAlertController(title: "로그인", message: "로그인성공!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .cancel)
                
                testAlert.addAction(alertAction)
                
                owner.present(testAlert, animated: true)
            }
            
        }.disposed(by: disposeBag)
    }
}

