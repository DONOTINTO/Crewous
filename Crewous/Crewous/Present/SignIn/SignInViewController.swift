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
            
            let nextVC = SignUpViewController()
            owner.navigationController?.pushViewController(nextVC, animated: true)
            
        }.disposed(by: disposeBag)
        
        // MARK: ViewModel
        let input = SignInViewModel.Input(
            emailText: layoutView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: layoutView.passwordTextField.rx.text.orEmpty.asObservable(),
            signInButtonTap: layoutView.signInButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // SignIn 버튼 터치 가능 여부 판단
        output.signInTouchEnabled.drive(layoutView.signInButton.rx.isEnabled).disposed(by: disposeBag)
        
        // SignIn 버튼 클릭 직후 애니메이션
        output.signInButtonTap.drive(with: self) { owner, _ in
            
            owner.layoutView.indicator.startAnimating()
            owner.layoutView.signInButton.animate()
        }.disposed(by: disposeBag)
        
        // SignIn 성공
        output.signInSuccess.drive(with: self) { owner, _ in
            owner.layoutView.indicator.stopAnimating()
            owner.layoutView.signInValidLabel.isHidden = true
            // 로그인 -> 다음 화면 넘어가기
            owner.makeAlert(msg: "SignIn") { _ in
                
                let testVC = StatsViewController()
                owner.navigationController?.pushViewController(testVC, animated: true)
            }
            
        }.disposed(by: disposeBag)
        
        // SignIn 실패
        output.signInFailure.drive(with: self) { owner, apiError in
            
            // 공통 오류 -> 강제 종료
            if apiError.checkCommonError() {
                owner.forceQuit(apiError.rawValue)
            }
            
            owner.layoutView.indicator.stopAnimating()
            
            switch apiError {
            case .code400:
                owner.makeAlert(msg: "이메일, 비밀번호를 입력해주세요.")
            case .code401:
                owner.makeAlert(msg: "이메일, 비밀번호를 확인해주세요.")
            default:
                return
            }
        }.disposed(by: disposeBag)
    }
}

