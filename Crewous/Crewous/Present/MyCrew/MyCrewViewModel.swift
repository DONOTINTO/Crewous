//
//  MyCrewViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyCrewViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let refreshObservable = PublishRelay<Void>()
    
    struct Input {
        
        let viewWillAppearObservable: Observable<Void>
    }
    
    struct Output {
        
        let fetchCrewSuccess: PublishRelay<FetchMyCrewDataModel>
        let fetchFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let fetchCrewSuccess = PublishRelay<FetchMyCrewDataModel>()
        let fetchFailure = PublishRelay<APIError>()
        
        // view will appear 시 Fetch My Crew 호출
        input.viewWillAppearObservable
            .flatMap {
                
                return APIManager.callAPI(router: Router.fetchMyCrew, dataModel: FetchMyCrewDataModel.self)
            }.subscribe(with: self) { owner, fetchMyCrewData in
                
                switch fetchMyCrewData {
                case .success(let data):
                    
                    fetchCrewSuccess.accept(data)
                case .failure(let apiError):
                    
                    fetchFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        refreshObservable
            .flatMap {
                
                return APIManager.callAPI(router: Router.fetchMyCrew, dataModel: FetchMyCrewDataModel.self)
            }.subscribe(with: self) { owner, fetchMyCrewData in
                
                switch fetchMyCrewData {
                case .success(let data):
                    
                    fetchCrewSuccess.accept(data)
                case .failure(let apiError):
                    
                    fetchFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        return Output(fetchCrewSuccess: fetchCrewSuccess, fetchFailure: fetchFailure)
    }
}
