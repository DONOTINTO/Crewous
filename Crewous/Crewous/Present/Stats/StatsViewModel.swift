//
//  StatsViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StatsViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
        let viewWillAppearObservable: Observable<Void>
        let profileChangeObservable: PublishRelay<Data>
    }
    
    struct Output {
        
        let fetchSelfSuccess: PublishRelay<FetchUserDataModel>
        let fetchCrewSuccess: PublishRelay<FetchMyCrewDataModel>
        let fetchFailure: PublishRelay<APIError>
        
        let updateProfileSuccess: PublishRelay<FetchUserDataModel>
        let updateProfileFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let fetchSelfSuccess = PublishRelay<FetchUserDataModel>()
        let fetchCrewSuccess = PublishRelay<FetchMyCrewDataModel>()
        let fetchFailure = PublishRelay<APIError>()
        
        let fetchMyCrew = PublishRelay<Void>()
        let updateProfileSuccess = PublishRelay<FetchUserDataModel>()
        let updateProfileFailure = PublishRelay<APIError>()
        
        // 내 정보 가져오기 (200 / 401 / 403 / 409)
        input.viewWillAppearObservable
            .flatMap { _ in
                
                return APIManager.callAPI(router: Router.fetchSelf,
                                          dataModel: FetchUserDataModel.self)
            }.subscribe(with: self) { owner, fetchSelfData in
                
                switch fetchSelfData {
                case .success(let data):
                    
                    fetchSelfSuccess.accept(data)
                    // 내 정보를 가져왔으면 크루 정보 가져오기
                    fetchMyCrew.accept(())
                case .failure(let apiError):
                    
                    fetchFailure.accept(apiError)
                }
                
            }.disposed(by: disposeBag)
        
        // 좋아요2를 누른 포스트(내가 가입한 크루) 정보 가져오기 (200 / 400 / 401 / 403 / 410 / 419)
        fetchMyCrew
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
        
        // 프로필 변경
        input.profileChangeObservable
            .flatMap { data in
                
                let query = UpdateProfileQuery(profile: data)
                return APIManager.uploadImage(router: Router.updateProfile(query: query), dataModel: FetchUserDataModel.self, image: data)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let success):
                    
                    updateProfileSuccess.accept(success)
                case .failure(let apiError):
                    
                    updateProfileFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        return Output(fetchSelfSuccess: fetchSelfSuccess,
                      fetchCrewSuccess: fetchCrewSuccess,
                      fetchFailure: fetchFailure,
                      updateProfileSuccess: updateProfileSuccess,
                      updateProfileFailure: updateProfileFailure)
    }
}
