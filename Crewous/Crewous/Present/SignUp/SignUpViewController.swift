//
//  SignUpViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController<SignUpView> {
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        super.bind()
        
        // MARK: Tap Gesture
        let tapGesture = UITapGestureRecognizer()
        layoutView.scrollViewAddTapGesture(tapGesture)
        
        tapGesture.rx.event.subscribe(with: self) { owner, _ in
            
            owner.layoutView.scrollViewEndEditing()
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
                
                owner.layoutView.hideEmailValidLabel(isValid)
                
            }.disposed(by: disposeBag)
        
        // 비밀번호
        output.passwordValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.hidePasswordValidLabel(isValid)
                
            }.disposed(by: disposeBag)
        
        // 닉네임
        output.nickValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.hideNickValidLabel(isValid)
                
            }.disposed(by: disposeBag)
        
        // 키
        output.heightValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.hideHeightValidLabel(isValid)
                
            }.disposed(by: disposeBag)
        
        // 몸무게
        output.weightValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.hideWeightValidLabel(isValid)
                
            }.disposed(by: disposeBag)
        
        // 포지션
        output.positionValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.hidePositionValidLabel(isValid)
                
            }.disposed(by: disposeBag)
        
        // 버튼 활성화/비활성화
        output.signUpButtonValidation
            .drive(with: self) { owner, isValid in
                
                owner.layoutView.signUpButtonEnabled(isValid)
                
            }.disposed(by: disposeBag)
        
        // 회원가입 버튼 클릭
        output.signUpButtonTap
            .drive(with: self) { owner, _ in
                
                owner.layoutView.indicatorStatus(isStart: true)
                
            }.disposed(by: disposeBag)
        
        // 회원가입 성공
        output.signUpSuccess.drive(with: self) { owner, _ in
            
            owner.layoutView.indicatorStatus(isStart: false)
            
            // 가입 완료 안내 alert 띄우기
            owner.makeAlert(msg: "SignUp") { _ in
                owner.navigationController?.popViewController(animated: true)
            }
            
        }.disposed(by: disposeBag)
        
        // 회원가입 실패
        output.signUpFailure.drive(with: self) { owner, apiError in
            
            owner.layoutView.indicatorStatus(isStart: false)
            owner.errorHandler(apiError, calltype: .signUp)
            
        }.disposed(by: disposeBag)
    }
}
