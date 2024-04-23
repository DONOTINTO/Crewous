//
//  SearchViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
        let searchButtonClickedObservable: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.searchButtonClickedObservable
            .flatMap {
                
                let fetchCrewQeury = FetchCrewQuery(limit: "100", product_id: ProductID.crew.rawValue)
                print("#### Fetch Crew API Call ####")
                return APIManager.callAPI(router: Router.fetchCrew(fetchCrewQuery: fetchCrewQeury), dataModel: FetchCrewDataModel.self)
            }.subscribe(with: self) { owner, fetchCrewData in
                
                switch fetchCrewData {
                    
                case .success(let data):
                    print("#### Fetch Crew API Success ####")
                    dump(data)
                case .failure(let apiError):
                    print("#### Fetch Crew API Fail - ErrorCode = \(apiError.rawValue) ####")
                    dump(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        return Output()
    }
}
