//
//  MyCrewViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class MyCrewViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var crewUsersData: [FetchUserDataModel] = []
    
    struct Input {
        
        let viewWillAppearObservable: Observable<Void>
    }
    
    struct Output {
        
        let fetchCrewSuccess: PublishRelay<FetchMyCrewDataModel>
        let fetchFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let crewUsers = PublishRelay<[String]>()
        
        let fetchCrewSuccess = PublishRelay<FetchMyCrewDataModel>()
        let fetchUserDataSuccess = PublishRelay<FetchUserDataModel>()
        
        let fetchFailure = PublishRelay<APIError>()
        let fetchUserDataFailure = PublishRelay<APIError>()
        
        input.viewWillAppearObservable
            .flatMap {
                
                return APIManager.callAPI(router: Router.fetchMyCrew, dataModel: FetchMyCrewDataModel.self)
            }.subscribe(with: self) { owner, fetchMyCrewData in
                
                switch fetchMyCrewData {
                case .success(let data):
                    
                    fetchCrewSuccess.accept(data)
                    crewUsers.accept(data.data[0].likes2)
                case .failure(let apiError):
                    
                    fetchFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        let crewUsersObservable = crewUsers.flatMap {
            Observable.from($0)
        }
        
        crewUsersObservable.flatMap {
            
            print("CrewUserObservable ---------Start")
            return APIManager.callAPI(router: Router.fetchUser(userID: $0), dataModel: FetchUserDataModel.self)
        }.subscribe(with: self) { owner, fetchUserData in
            
            switch fetchUserData {
            case .success(let data):
                print("CrewUserObservable ---------success")
                dump(data)
                owner.crewUsersData.append(data)
            case .failure(let apiError):
                print("CrewUserObservable ---------failure")
                fetchUserDataFailure.accept(apiError)
            }
        }.disposed(by: disposeBag)
        
        
        return Output(fetchCrewSuccess: fetchCrewSuccess, fetchFailure: fetchFailure)
    }
}
