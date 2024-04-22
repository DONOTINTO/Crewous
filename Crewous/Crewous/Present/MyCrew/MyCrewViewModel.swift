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
                
                print("#### Fetch Crew API Call ####")
                return APIManager.callAPI(router: Router.fetchMyCrew, dataModel: FetchMyCrewDataModel.self)
            }.subscribe(with: self) { owner, fetchMyCrewData in
                
                switch fetchMyCrewData {
                case .success(let data):
                    
                    print("#### Fetch Crew API Success ####")
                    fetchCrewSuccess.accept(data)
                case .failure(let apiError):
                    
                    print("#### Fetch Crew API Fail - ErrorCode = \(apiError.rawValue) ####")
                    fetchFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        return Output(fetchCrewSuccess: fetchCrewSuccess, fetchFailure: fetchFailure)
    }
}
