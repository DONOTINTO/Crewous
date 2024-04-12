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

    let viewModel = SignUpViewModel()
    
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
        
        // MARK: View Model
        let input = SignUpViewModel.Input(
            emailText: layoutView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: layoutView.passwordTextField.rx.text.orEmpty.asObservable(),
            nickText: layoutView.nickTextField.rx.text.orEmpty.asObservable(),
            heightText: layoutView.heightTextField.rx.text.orEmpty.asObservable(),
            weightText: layoutView.weightTextField.rx.text.orEmpty.asObservable(),
            positionText: layoutView.positionTextField.rx.text.orEmpty.asObservable(),
            signUpButtonTap: layoutView.signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // 이메일
        output.emailValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.emailValidLabel.isHidden = isValid
                
                if owner.layoutView.emailTextField.text == "" {
                    owner.layoutView.emailValidLabel.isHidden = true
                }
                
            }.disposed(by: disposeBag)
        
        // 비밀번호
        output.passwordValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.passwordValidLabel.isHidden = isValid
                
                if owner.layoutView.passwordTextField.text == "" {
                    owner.layoutView.passwordValidLabel.isHidden = true
                }
                
            }.disposed(by: disposeBag)
        
        // 닉네임
        output.nickValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.nickValidLabel.isHidden = isValid
                
                if owner.layoutView.nickTextField.text == "" {
                    owner.layoutView.nickValidLabel.isHidden = true
                }
                
            }.disposed(by: disposeBag)
        
        // 키
        output.heightValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.heightValidLabel.isHidden = isValid
                
                if owner.layoutView.heightTextField.text == "" {
                    owner.layoutView.heightValidLabel.isHidden = true
                }
                
            }.disposed(by: disposeBag)
        
        // 몸무게
        output.weightValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.weightValidLabel.isHidden = isValid
                
                if owner.layoutView.weightTextField.text == "" {
                    owner.layoutView.weightValidLabel.isHidden = true
                }
                
            }.disposed(by: disposeBag)
        
        // 포지션
        output.positionValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.positionValidLabel.isHidden = isValid
                
                if owner.layoutView.positionTextField.text == "" {
                    owner.layoutView.positionValidLabel.isHidden = true
                }
                
            }.disposed(by: disposeBag)
        
        // 버튼 활성화/비활성화
        output.signUpButtonValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.signUpButton.isEnabled = isValid
                
            }.disposed(by: disposeBag)
    }
}