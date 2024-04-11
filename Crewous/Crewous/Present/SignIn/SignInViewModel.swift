//
//  SignInViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let signInButtonTap: Observable<Void>
    }
    
    struct Output {
        let signInTouchEnabled: PublishRelay<Bool>
        let signInValidation: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let signInTouchEnabled = PublishRelay<Bool>()
        let signInValidation = PublishRelay<Bool>()
        
        Observable.combineLatest(input.emailText, input.passwordText)
            .subscribe(with: self) { owner, input in
                
                let (email, password) = input
                
                // 이메일, 패스워드 모두 입력했으면 Sign In Button 활성화
                signInTouchEnabled.accept((!email.isEmpty && !password.isEmpty))
                
            }.disposed(by: disposeBag)
        
        input.signInButtonTap.bind(with: self) { owner, _ in
            
            // 로그인 시도
            // -> 성공 : accessToken / refreshToken 저장 -> 다음 화면
            // -> 실패 : 불일치 안내 문구표기
            signInValidation.accept(true)
        }.disposed(by: disposeBag)
        
        return Output(signInTouchEnabled: signInTouchEnabled, signInValidation: signInValidation)
    }
}
