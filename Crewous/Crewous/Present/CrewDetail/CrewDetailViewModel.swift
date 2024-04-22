//
//  CrewDetailViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import Foundation
import RxSwift
import RxCocoa

class CrewDetailViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let postIdentifier = PublishRelay<String>()
    
    struct Input {
        
        let postIdentifierObservable: PublishRelay<String>
    }
    
    struct Output {
        
        let postDataSuccess: PublishRelay<PostData>
        let postDataFailure: PublishRelay<APIError>
        
        let userDataSuccess: PublishRelay<[FetchUserDataModel]>
        let userDataFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let dispatchGroup = DispatchGroup()
        var usersData = [FetchUserDataModel]()
        
        let postDataSuccess = PublishRelay<PostData>()
        let postDataFailure = PublishRelay<APIError>()
        
        let userDataSuccess = PublishRelay<[FetchUserDataModel]>()
        let userDataFailure = PublishRelay<APIError>()
        
        let fetchUserIdentifier = PublishRelay<String>()
        
        input.postIdentifierObservable.flatMap {
            
            print("#### Fetch Post Data API Call ####")
            return APIManager.callAPI(router: Router.fetchPost(postID: $0), dataModel: PostData.self)
        }.subscribe(with: self) { owner, fetchPost in
            
            switch fetchPost {
            case .success(let postData):
                
                print("#### Fetch Post Data API Success ####")
                postDataSuccess.accept(postData)
                
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
                            userDataSuccess.accept(usersData)
                        }
                    }.disposed(by: owner.disposeBag)
                
            case .failure(let apiError):
                
                print("#### Fetch Post Data API Fail - ErrorCode = \(apiError.rawValue) ####")
                postDataFailure.accept(apiError)
            }
        }.disposed(by: disposeBag)
        
        fetchUserIdentifier.flatMap {
            
            dispatchGroup.enter()
            print("#### Fetch User Data API Call ####")
            return APIManager.callAPI(router: Router.fetchUser(userID: $0), dataModel: FetchUserDataModel.self)
        }.subscribe(with: self) { owner, fetchUserData in
            
            switch fetchUserData {
                
            case .success(let userData):
                
                print("#### Fetch User Data API Success ####")
                usersData.append(userData)
                
            case .failure(let apiError):
                
                userDataFailure.accept(apiError)
            }
            
            dispatchGroup.leave()
            
        }.disposed(by: disposeBag)
        
        return Output(postDataSuccess: postDataSuccess,
                      postDataFailure: postDataFailure,
                      userDataSuccess: userDataSuccess,
                      userDataFailure: userDataFailure)
    }
}
