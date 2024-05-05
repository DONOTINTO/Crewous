//
//  SignInViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let signInButtonTap: Observable<Void>
    }
    
    struct Output {
        let signInTouchEnabled: Driver<Bool>
        let signInButtonTap: Driver<Void>
        let signInSuccess: Driver<Void>
        let signInFailure: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let signInTouchEnabled = PublishRelay<Bool>()
        let signInButtonTap = PublishRelay<Void>()
        let signInSuccess = PublishRelay<Void>()
        let signInFailure = PublishRelay<APIError>()
        
        // Sign In Query로 변환
        let signInQuery = Observable.combineLatest(input.emailText, input.passwordText)
            .map { signInData in
                
                let (email, password) = signInData
                
                return SignInQuery(email: email, password: password)
            }
        
        // 이메일 비밀번호 입력 체크
        signInQuery.subscribe(with: self) { owner, signInData in
            
            let email = signInData.email, password = signInData.password
            
            // 이메일, 패스워드 모두 입력했으면 Sign In Button 활성화
            signInTouchEnabled.accept((!email.isEmpty && !password.isEmpty))
        }.disposed(by: disposeBag)
        
        // 로그인 API 호출
        input.signInButtonTap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(signInQuery)
            .flatMap { signInQuery in
                
                signInButtonTap.accept(())
                
                return APIManager.callAPI(
                    router: Router.signIn(signInQuery: signInQuery),
                    dataModel: SignInDataModel.self)
            }.subscribe(with: self) { owner, signInData in
                
                switch signInData {
                case .success(let data):
                    
                    //데이터 저장 (accessToken / refreshToken / isLogin / UserID)
                    UDManager.accessToken = data.accessToken
                    UDManager.refreshToken = data.refreshToken
                    UDManager.isLogin = true
                    UDManager.userID = data.userID
                    
                    signInSuccess.accept(())
                case .failure(let apiError):
                    
                    signInFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        return Output(signInTouchEnabled: signInTouchEnabled.asDriver(onErrorJustReturn: false),
                      signInButtonTap: signInButtonTap.asDriver(onErrorJustReturn: ()),
                      signInSuccess: signInSuccess.asDriver(onErrorJustReturn: ()),
                      signInFailure: signInFailure.asDriver(onErrorJustReturn: .unknownError))
    }
}
