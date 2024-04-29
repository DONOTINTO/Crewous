//
//  MakeCrewViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class MakeCrewViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var imageData: Data!
    var crewID: String = ""
    var imageFiles: [String] = []
    
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
                
                print("#### UploadImage API Call ####")
                let query = UploadImageQuery(files: self.imageData)
                return APIManager.uploadImage(router: Router.uploadImage(uploadImageQuery: query), dataModel: UploadImageDataModel.self, image: self.imageData)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let data):
                    
                    print("#### UploadImage API Success ####")
                    owner.imageFiles = data.files
                    uploadImageSuccess.accept(data)
                case .failure(let apiError):
                    
                    print("#### UploadImage API Fail - ErrorCode = \(apiError.rawValue) ####")
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
                print("#### MakeCrew API Call ####")
                return APIManager.callAPI(router: Router.makeCrew(makeCrewQuery: makeCrewQuery), dataModel: PostData.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let data):
                    print("#### Make Crew API Success ####")
                    owner.crewID = data.postID
                    makeCrewSuccess.accept(data)
                case .failure(let apiError):
                    print("#### Make Crew API Fail - ErrorCode = \(apiError.rawValue) ####")
                    makeCrewFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        // 생성된 포스터 like2 API 호출
        input.like2Observable
            .flatMap { productID in
                
                print("#### Like2 API Call ####")
                return APIManager.callAPI(router: Router.like2(postID: productID, query: Like2Query(like_status: true)), dataModel: Like2DataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(_):
                    print("#### Like2 API Success ####")
                    like2Success.accept(())
                case .failure(let apiError):
                    print("#### Like2 API Fail - ErrorCode = \(apiError.rawValue) ####")
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
