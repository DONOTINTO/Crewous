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
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        let uploadImageData = PublishRelay<UploadImageDataModel>()
        
        let uploadImageFailure = PublishRelay<APIError>()
        
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
        
        return Output()
    }
}
