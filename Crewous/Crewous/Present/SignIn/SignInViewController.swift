//
//  SignInViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController<SignInView> {

    private let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        super.bind()
        
        // MARK: Tap Gesture
        let tapGesture = UITapGestureRecognizer()
        layoutView.addTapGesture(tapGesture)
        
        // SignUP(회원가입) 이동
        tapGesture.rx.event.bind(with: self) { owner, _ in
            
            let nextVC = SignUpViewController()
            owner.navigationController?.pushViewController(nextVC, animated: true)
            
        }.disposed(by: disposeBag)
        
        // MARK: ViewModel
        let input = SignInViewModel.Input(
            emailText: layoutView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: layoutView.passwordTextField.rx.text.orEmpty.asObservable(),
            signInButtonTap: layoutView.signInButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        // SignIn(로그인) 버튼 터치 가능 여부 판단
        output.signInTouchEnabled.drive(layoutView.signInButton.rx.isEnabled).disposed(by: disposeBag)
        
        // SignIn(로그인) 버튼 클릭 직후 애니메이션
        output.signInButtonTap.drive(with: self) { owner, _ in
            
            owner.layoutView.indicatorStatus(isStart: true)
        }.disposed(by: disposeBag)
        
        // SignIn 성공
        output.signInSuccess.drive(with: self) { owner, _ in
            
            owner.layoutView.indicatorStatus(isStart: false)
            owner.layoutView.signInvalidLabelStatus(isHidden: true)
            
            // 로그인 -> Stats 화면으로 이동
            owner.makeAlert(msg: "SignIn") { _ in
                
                owner.changeRootViewToStats()
            }
            
        }.disposed(by: disposeBag)
        
        // SignIn 실패
        output.signInFailure.drive(with: self) { owner, apiError in
            
            owner.layoutView.indicatorStatus(isStart: false)
            owner.layoutView.signInvalidLabelStatus(isHidden: false)
            
            owner.errorHandler(apiError, calltype: .signIn)
            
        }.disposed(by: disposeBag)
    }
}

