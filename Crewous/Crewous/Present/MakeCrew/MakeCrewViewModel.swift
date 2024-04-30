//
//  MakeCrewViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MakeCrewViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // 이미지 데이터
    var imageData: Data!
    
    // 포스트 생성 후 Like2 실패시 재시도 용도
    var postID: String = ""
    
    //이미지 업로드 후 리턴 값 임시 저장
    private var imageFiles: [String] = []
    
    struct Input {
        
        let createButtonObservable: Observable<Void>
        let inputDataObservable: Observable<(String, String, String, String, String, String)>
        let like2Observable: PublishRelay<String>
    }
    
    struct Output {
        let makeCrewSuccess: PublishRelay<PostData>
        let like2Success: PublishRelay<Void>
        
        let uploadImageFailure: PublishRelay<APIError>
        let makeCrewFailure: PublishRelay<APIError>
        let like2Failure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let uploadImageSuccess = PublishRelay<UploadImageDataModel>()
        let makeCrewSuccess = PublishRelay<PostData>()
        let like2Success = PublishRelay<Void>()
        
        let uploadImageFailure = PublishRelay<APIError>()
        let makeCrewFailure = PublishRelay<APIError>()
        let like2Failure = PublishRelay<APIError>()
        
        // 이미지 업로드 API 호출
        input.createButtonObservable
            .flatMap { 
                
                let query = UploadImageQuery(files: self.imageData)
                return APIManager.uploadImage(router: Router.uploadImage(uploadImageQuery: query), dataModel: UploadImageDataModel.self, image: self.imageData)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let data):
                    
                    owner.imageFiles = data.files
                    uploadImageSuccess.accept(data)
                case .failure(let apiError):
                    
                    uploadImageFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        // make crew query 생성
        let createCrewObservable = uploadImageSuccess.withLatestFrom(input.inputDataObservable)
            .map { [weak self] inputData in
                
                return MakeCrewQuery(title: inputData.0,
                                     content: inputData.1,
                                     content1: inputData.2,
                                     content2: inputData.3,
                                     content3: inputData.4,
                                     content4: inputData.5,
                                     product_id: ProductID.crew.rawValue,
                                     files: self?.imageFiles ?? [])
            }
        
        
        // 포스터(크루 생성) 업로드 API 호출
        createCrewObservable
            .flatMap { makeCrewQuery in
                
                return APIManager.callAPI(router: Router.makeCrew(makeCrewQuery: makeCrewQuery), dataModel: PostData.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let data):
                    
                    owner.postID = data.postID
                    makeCrewSuccess.accept(data)
                case .failure(let apiError):
                    
                    makeCrewFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        // 생성된 포스터 like2 API 호출
        input.like2Observable
            .flatMap { postID in
                
                return APIManager.callAPI(router: Router.like2(postID: postID, query: Like2Query(like_status: true)), dataModel: Like2DataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(_):
                    
                    like2Success.accept(())
                case .failure(let apiError):
                    
                    like2Failure.accept(apiError)
                }
            }.disposed(by: disposeBag)
            
        return Output(makeCrewSuccess: makeCrewSuccess,
                      like2Success: like2Success,
                      uploadImageFailure: uploadImageFailure,
                      makeCrewFailure: makeCrewFailure,
                      like2Failure: like2Failure)
    }
}
