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
    
    struct Input {
        
        let createButtonObservable: Observable<Void>
        let inputDataObservable: Observable<(String, String, String, String, String, String)>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        let uploadImageData = PublishRelay<UploadImageDataModel>()
        
        let uploadImageFailure = PublishRelay<APIError>()
        let makeCrewFailure = PublishRelay<APIError>()
        
        // 이미지 업로드 API 호출
        input.createButtonObservable
            .flatMap {
                
                print("#### UploadImage API Call ####")
                return APIManager.uploadImage(router: Router.uploadImage, dataModel: UploadImageDataModel.self, image: self.imageData)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let data):
                    
                    print("#### UploadImage API Success ####")
                    uploadImageData.accept(data)
                case .failure(let apiError):
                    
                    print("#### UploadImage API Fail - ErrorCode = \(apiError.rawValue) ####")
                    uploadImageFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        // make crew query 생성
        let createCrewObservable = Observable.combineLatest(input.inputDataObservable, uploadImageData)
            .map { data in
                let (inputData, imageData) = data
                
                return MakeCrewQuery(title: inputData.0,
                                     content: inputData.1,
                                     content1: inputData.2,
                                     content2: inputData.3,
                                     content3: inputData.4,
                                     content4: inputData.5,
                                     product_id: ProductID.crew.rawValue,
                                     files: imageData.files)
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
                    dump(data)
                case .failure(let apiError):
                    print("#### Make Crew API Fail - ErrorCode = \(apiError.rawValue) ####")
                    makeCrewFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        
        return Output()
    }
}
