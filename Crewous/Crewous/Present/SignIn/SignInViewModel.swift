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
        let signInButtonTap: PublishRelay<Void>
        let signInValidation: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let signInTouchEnabled = PublishRelay<Bool>()
        let signInButtonTap = PublishRelay<Void>()
        let signInValidation = PublishRelay<Bool>()
        
        // Sign In Query로 변환
        let signInObservable = Observable.combineLatest(input.emailText, input.passwordText)
            .map { signInData in
                
                let (email, password) = signInData
                
                return SignInQuery(email: email, password: password)
            }
        
        // 이메일 비밀번호 입력 체크
        signInObservable.subscribe(with: self) { owner, signInData in
            
            let email = signInData.email, password = signInData.password
            
            // 이메일, 패스워드 모두 입력했으면 Sign In Button 활성화
            signInTouchEnabled.accept((!email.isEmpty && !password.isEmpty))
            
            return
        }.disposed(by: disposeBag)
        
        // 로그인 API 호출
        input.signInButtonTap
            .withLatestFrom(signInObservable)
            .debug()
            .flatMap { signInQuery in
                
                signInButtonTap.accept(())
                
                print("#### Sign In API Call ####")
                return APIManager.callAPI(
                    router: Router.login(loginQuery: signInQuery),
                    dataModel: SignInDataModel.self)
            }.subscribe(with: self) { owner, signInData in
                
                switch signInData {
                case .success(let data):
                    
                    print("#### Sign In API Success ####")
                    //데이터 저장 (accessToken / refreshToken / isLogin)
                    UDManager.accessToken = data.accessToken
                    UDManager.refreshToken = data.refreshToken
                    UDManager.isLogin = true
                    
                    signInValidation.accept(true)
                case .failure(let error):
                    
                    print("#### Sign In API Fail - ErrorCode = \(error.rawValue) ####")
                    signInValidation.accept(false)
                }
            }.disposed(by: disposeBag)
        
        return Output(signInTouchEnabled: signInTouchEnabled, signInButtonTap: signInButtonTap, signInValidation: signInValidation)
    }
}
