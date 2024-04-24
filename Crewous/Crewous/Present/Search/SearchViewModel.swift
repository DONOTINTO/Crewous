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
        let searchTextObservable: Observable<String>
    }
    
    struct Output {
        
        let searchResultObservable: PublishRelay<[PostData]>
        let searchResultFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let searchResultObservable = PublishRelay<[PostData]>()
        let searchResultFailure = PublishRelay<APIError>()
        
        let fetchCrewData = input.searchButtonClickedObservable
            .flatMap {
                
                let fetchCrewQeury = FetchCrewQuery(limit: "100", product_id: ProductID.crew.rawValue)
                print("#### Fetch Crew API Call ####")
                return APIManager.callAPI(router: Router.fetchCrew(fetchCrewQuery: fetchCrewQeury), dataModel: FetchCrewDataModel.self)
            }
        
        let searchTextObservable = input.searchTextObservable
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        Observable.combineLatest(fetchCrewData, searchTextObservable)
            .subscribe(with: self) { owner, data in
                
                let (fetchCrewData, search) = data
                
                switch fetchCrewData {
                    
                case .success(let success):
                    
                    let filteredData = owner.filteredPostData(success.data, search)
                    searchResultObservable.accept(filteredData)
                    
                case .failure(let apiError):
                    
                    searchResultFailure.accept(apiError)
                }
        }.disposed(by: disposeBag)
        
        return Output(searchResultObservable: searchResultObservable, searchResultFailure: searchResultFailure)
    }
    
    private func filteredPostData(_ data: [PostData], _ input: String) -> [PostData] {
        
        return data.filter { data in
            
            guard let name = data.crewName else { return false }
            
            return name.contains(input)
        }
    }
}
