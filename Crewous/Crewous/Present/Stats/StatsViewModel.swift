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
        
        let fetchSuccess: PublishRelay<FetchSelfDataModel>
        let fetchFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let fetchSuccess = PublishRelay<FetchSelfDataModel>()
        let fetchFailure = PublishRelay<APIError>()
        
        input.viewWillAppearObservable
            .flatMap { _ in
                
                return APIManager.callAPI(router: Router.fetchSelf,
                                          dataModel: FetchSelfDataModel.self)
            }.subscribe(with: self) { owner, fetchSelfData in
                
                switch fetchSelfData {
                case .success(let data):
                    print("#### Fetch Self API Success ####")
                    fetchSuccess.accept(data)
                case .failure(let apiError):
                    print("#### Fetch Self API Fail - ErrorCode = \(apiError.rawValue) ####")
                    fetchFailure.accept(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        return Output(fetchSuccess: fetchSuccess,
                      fetchFailure: fetchFailure)
    }
}
