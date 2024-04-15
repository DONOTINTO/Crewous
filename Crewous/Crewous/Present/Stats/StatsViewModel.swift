//
//  StatsViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class StatsViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
        let viewWillAppearObservable: Observable<Void>
    }
    
    struct Output {
        
        let fetchSelfSuccess: PublishRelay<FetchSelfDataModel>
        let fetchCrewSuccess: PublishRelay<FetchMyCrewDataModel>
        let fetchFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let fetchSelfSuccess = PublishRelay<FetchSelfDataModel>()
        let fetchCrewSuccess = PublishRelay<FetchMyCrewDataModel>()
        let fetchFailure = PublishRelay<APIError>()
        let fetchMyCrew = PublishRelay<Void>()
        
        input.viewWillAppearObservable
            .flatMap { _ in
                
                return APIManager.callAPI(router: Router.fetchSelf,
                                          dataModel: FetchSelfDataModel.self)
            }.subscribe(with: self) { owner, fetchSelfData in
                
                switch fetchSelfData {
                case .success(let data):
                    print("#### Fetch Self API Success ####")
                    fetchSelfSuccess.accept(data)
                    fetchMyCrew.accept(())
                case .failure(let apiError):
                    print("#### Fetch Self API Fail - ErrorCode = \(apiError.rawValue) ####")
                    fetchFailure.accept(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        fetchMyCrew
            .flatMap {
                
                return APIManager.callAPI(router: Router.fetchMyCrew, dataModel: FetchMyCrewDataModel.self)
            }.subscribe(with: self) { owner, fetchMyCrewData in
                
                switch fetchMyCrewData {
                    
                case .success(let data):
                    print("#### Fetch Crew API Success ####")
                    fetchCrewSuccess.accept(data)
                case .failure(let apiError):
                    fetchFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        return Output(fetchSelfSuccess: fetchSelfSuccess,
                      fetchCrewSuccess: fetchCrewSuccess,
                      fetchFailure: fetchFailure)
    }
}
