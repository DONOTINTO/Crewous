//
//  SignUpViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let nickText: Observable<String>
        let heightText: Observable<String>
        let weightText: Observable<String>
        let positionText: Observable<String>
        let signUpButtonTap: Observable<Void>
    }
    
    struct Output {
        let emailValidation: Driver<Bool>
        let passwordValidation: Driver<Bool>
        let nickValidation: Driver<Bool>
        let heightValidation: Driver<Bool>
        let weightValidation: Driver<Bool>
        let positionValidation: Driver<Bool>
        let signUpButtonValidation: Driver<Bool>
        let signUpButtonTap: Driver<Void>
        
        let signUpSuccess: Driver<Void>
        let signUpFailure: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValidation = PublishRelay<Bool>()
        let passwordValidation = PublishRelay<Bool>()
        let nickValidation = PublishRelay<Bool>()
        let heightValidation = PublishRelay<Bool>()
        let weightValidation = PublishRelay<Bool>()
        let positionValidation = PublishRelay<Bool>()
        let signUpButtonValidation = PublishRelay<Bool>()
        
        let signUpSuccess = PublishRelay<Void>()
        let signUpFailure = PublishRelay<APIError>()
        
        // 이메일 정규식 체크
        input.emailText.bind(with: self) { owner, email in
            
            let isValid = Util.RegularExpression.validateEmail(email)
            emailValidation.accept(isValid)
            
        }.disposed(by: disposeBag)
        
        // 비밀번호 정규식 체크
        input.passwordText.bind(with: self) { owner, password in
            
            let isValid = Util.RegularExpression.validatePassword(password)
            passwordValidation.accept(isValid)
            
        }.disposed(by: disposeBag)
        
        // 닉네임 2글자 이상 16자 이하 체크
        input.nickText.bind(with: self) { owner, nick in
            
            let isValid = (nick.count >= 2) && (nick.count <= 16)
            nickValidation.accept(isValid)
            
        }.disposed(by: disposeBag)
        
        // 키 숫자 입력 체크
        input.heightText.bind(with: self) { owner, height in
            
            let isValid = Util.Num.isDouble(height)
            heightValidation.accept(isValid)
            
        }.disposed(by: disposeBag)
        
        // 몸무게 숫자 입력 체크
        input.weightText.bind(with: self) { owner, weight in
            
            let isValid = Util.Num.isDouble(weight)
            weightValidation.accept(isValid)
            
        }.disposed(by: disposeBag)
        
        // 포지션
        input.positionText.bind(with: self) { owner, position in
            
            let isValid = (position.count >= 2) && (position.count <= 16)
            positionValidation.accept(isValid)
            
        }.disposed(by: disposeBag)
        
        // 모두 오류 없이 입력했는지 체크 -> Sign Up 버튼 활성화 여부
        Observable.combineLatest(emailValidation, passwordValidation, nickValidation, heightValidation, weightValidation, positionValidation)
            .subscribe(with: self) { owner, input in
                
                let (email, password, nick, height, weight, position) = input
                
                signUpButtonValidation.accept((email && password && nick && height && weight && position))
                
            }.disposed(by: disposeBag)
        
        // SignUpQuery 생성
        let signUpObservable = Observable.combineLatest(input.emailText, input.passwordText, input.nickText, input.heightText, input.weightText, input.positionText)
            .map { signUpData in
                
                let (email, password, nick, height, weight, position) = signUpData
                
                let proxy = "\(nick)/\(height)/\(weight)/\(position)"
                
                return SignUpQuery(email: email, password: password, nick: proxy)
            }
        
        // 회원가입 TODO: 회원가입 API 콜 및 처리
        input.signUpButtonTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .debug()
            .flatMap { signUpQuery in
                
                print("#### Sign In API Call ####")
                return APIManager.callAPI(
                    router: Router.signUp(signUpQuery: signUpQuery),
                    dataModel: SignUpDataModel.self)
            }.subscribe(with: self) { owner, signUpData in
                
                // 200 - 성공
                // 400 - 필수값 미입력 (미입력 방지 처리 완료)
                // 409 - 이미 가입한 이메일 (이메일 중복체크 필요 없을듯)
                switch signUpData {
                case .success:
                    
                    print("#### Sign In API Success ####")
                    signUpSuccess.accept(())
                case .failure(let apiError):
                    
                    print("#### Sign In API Fail - ErrorCode = \(apiError.rawValue) ####")
                    signUpFailure.accept(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        return Output(emailValidation: emailValidation.asDriver(onErrorJustReturn: false),
                      passwordValidation: passwordValidation.asDriver(onErrorJustReturn: false),
                      nickValidation: nickValidation.asDriver(onErrorJustReturn: false),
                      heightValidation: heightValidation.asDriver(onErrorJustReturn: false),
                      weightValidation: weightValidation.asDriver(onErrorJustReturn: false),
                      positionValidation: positionValidation.asDriver(onErrorJustReturn: false),
                      signUpButtonValidation: signUpButtonValidation.asDriver(onErrorJustReturn: false),
                      signUpButtonTap: input.signUpButtonTap.asDriver(onErrorJustReturn: ()),
                      signUpSuccess: signUpSuccess.asDriver(onErrorJustReturn: ()),
                      signUpFailure: signUpFailure.asDriver(onErrorJustReturn: .unknownError))
    }
}
