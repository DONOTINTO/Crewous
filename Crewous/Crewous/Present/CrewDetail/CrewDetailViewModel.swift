//
//  CrewDetailViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CrewDetailViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // My Crew VC, Search VC에서 전달받음
    let postIdentifier = PublishRelay<String>()
    
    var postData: PostData?
    var userData: [FetchUserDataModel]?
    
    struct Input {
        
        let viewWillAppearObservable: Observable<Void>
        let postIdentifierObservable: PublishRelay<String>
        let crewApplyButtonTapObservable: Observable<Void>
        let crewResignButtonTapObservable: Observable<Void>
    }
    
    struct Output {
        
        let postDataSuccess: PublishRelay<PostData>
        let postDataFailure: PublishRelay<APIError>
        
        let userDataSuccess: PublishRelay<[FetchUserDataModel]>
        let userDataFailure: PublishRelay<APIError>
        
        let notRegistObservable: PublishRelay<Void>
        let isMyCrewObservable: PublishRelay<Bool>
        
        let fetchSelfFailure: PublishRelay<APIError>
        
        let applySuccess: PublishRelay<Void>
        let resignSuccess: PublishRelay<Void>
        let applyOrResignFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let dispatchGroup = DispatchGroup()
        // 크루원 유저 정보 임시 저장소
        var usersData = [FetchUserDataModel]()
        
        // 크루원(개개인) 유저 정보
        let fetchUserIdentifier = PublishRelay<String>()
        // 내가 가입한 크루인지 체크용
        // -> 내가 가입한 크루의 경우 APPLY 버튼 탈퇴 버튼으로 변경
        // -> 내가 가입하지 않은 크루의 경우 APPLY 버튼 비활성화
        let myCrewDataObservable = PublishRelay<PostData>()
        
        // MARK: OUTPUT
        // 크루(포스트) 정보 받아오기 성공
        let postDataSuccess = PublishRelay<PostData>()  // -> 완료 후 크루원 정보 호출 / 가입 여부 체크
        let postDataFailure = PublishRelay<APIError>()
        
        // 크루원(전원) 유저 정보
        let userDataSuccess = PublishRelay<[FetchUserDataModel]>()
        let userDataFailure = PublishRelay<APIError>()
        
        // 내가 가입한 크루가 있는지 체크
        // -> 없는 경우 APPLY 버튼 무조건 활성화, 탈퇴 버튼 비활성화
        let notRegist = PublishRelay<Void>()
        
        // 내가 가입한 크루가 맞는지 체크
        // -> 내가 가입한 크루의 경우 APPLY 비활성화, 탈퇴 버튼 활성화
        // -> 내가 가입한 크루가 아닌 경우 APPLY 비활성화
        let isMyCrew = PublishRelay<Bool>()
        
        // 내가 가입한 크루정보 가져오기 실패
        let fetchSelfFailure = PublishRelay<APIError>()
        
        // 가입 성공
        let applySuccess = PublishRelay<Void>()
        let resignSuccess = PublishRelay<Void>()
        let applyOrResignFailure = PublishRelay<APIError>()
        
        
        // MARK: 비즈니스 코드
        // Post Data(크루 정보) 호출
        input.postIdentifierObservable.flatMap {
            
            return APIManager.callAPI(router: Router.fetchPost(postID: $0), dataModel: PostData.self)
        }.subscribe(with: self) { owner, fetchPost in
            
            switch fetchPost {
            case .success(let postData):
                
                // Search로 들어갔을 때 대응
                owner.postData = postData
                
                postDataSuccess.accept(postData)
                
                // 가입한 유저(크루원) 정보 모두 취합
                Observable.from(postData.likes2)
                    .subscribe(with: self) { owner, data in
                        fetchUserIdentifier.accept(data)
                    } onCompleted: { _ in
                        
                        dispatchGroup.notify(queue: .main) {
                            
                            usersData.sort {
                                let firstNick = ($0.nick.split(separator: "/"))[3]
                                let secondNick = ($1.nick.split(separator: "/"))[3]
                                
                                return firstNick.count < secondNick.count
                            }
                            owner.userData = usersData
                            userDataSuccess.accept(usersData)
                            usersData = []
                        }
                    }.disposed(by: owner.disposeBag)
                
            case .failure(let apiError):
                
                postDataFailure.accept(apiError)
            }
        }.disposed(by: disposeBag)
        
        // User Data(크루원 정보) 호출
        fetchUserIdentifier.flatMap {
            
            dispatchGroup.enter()
            return APIManager.callAPI(router: Router.fetchUser(userID: $0), dataModel: FetchUserDataModel.self)
        }.subscribe(with: self) { owner, fetchUserData in
            
            switch fetchUserData {
                
            case .success(let userData):
                
                usersData.append(userData)
                
            case .failure(let apiError):
                
                userDataFailure.accept(apiError)
            }
            
            dispatchGroup.leave()
            
        }.disposed(by: disposeBag)
        
        // 내 크루 정보 호출
        input.viewWillAppearObservable
            .flatMap {
                
                APIManager.callAPI(router: Router.fetchMyCrew, dataModel: FetchMyCrewDataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let myCrewData):
                    
                    guard let myCrew = myCrewData.data.first else {
                        // 가입한 크루가 없음
                        notRegist.accept(())
                        return
                    }
                    
                    // 내가 가입한 크루 정보 전달
                    myCrewDataObservable.accept(myCrew)
                    
                case .failure(let apiError):
                    fetchSelfFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        // 내 크루와 포스트(크루) 일치 여부 판단
        Observable.zip(postDataSuccess, myCrewDataObservable)
            .subscribe(with: self) { owner, data in
                
                let (postCrewData, myCrewData) = data
                
                isMyCrew.accept(postCrewData.postID == myCrewData.postID)
            }.disposed(by: disposeBag)
        
        // 가입 버튼 클릭
        input.crewApplyButtonTapObservable
            .withLatestFrom(postDataSuccess)
            .flatMap { postData in
                
                return APIManager.callAPI(router: Router.like2(postID: postData.postID, query: Like2Query(like_status: true)), dataModel: Like2DataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(_):
                    applySuccess.accept(())
                case .failure(let apiError):
                    applyOrResignFailure.accept(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        // 탈퇴 버튼 클릭
        input.crewResignButtonTapObservable
            .withLatestFrom(postDataSuccess)
            .flatMap { postData in
                
                return APIManager.callAPI(router: Router.like2(postID: postData.postID, query: Like2Query(like_status: false)), dataModel: Like2DataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(_):
                    resignSuccess.accept(())
                case .failure(let apiError):
                    applyOrResignFailure.accept(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        
        return Output(postDataSuccess: postDataSuccess,
                      postDataFailure: postDataFailure,
                      userDataSuccess: userDataSuccess,
                      userDataFailure: userDataFailure,
                      notRegistObservable: notRegist,
                      isMyCrewObservable: isMyCrew,
                      fetchSelfFailure: fetchSelfFailure,
                      applySuccess: applySuccess,
                      resignSuccess: resignSuccess,
                      applyOrResignFailure: applyOrResignFailure)
    }
}
