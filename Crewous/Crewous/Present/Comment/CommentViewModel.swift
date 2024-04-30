//
//  CommentViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var postIdentifier: String = ""
    
    struct Input {
        
        let postIdentifier: PublishRelay<String>
        let commentInputObservable: Observable<String>
    }
    
    struct Output {
     
        let postDataSuccess: PublishRelay<[CrewComment]>
        let postDataFailure: PublishRelay<APIError>
        
        let commentSuccess: PublishRelay<Int>
        let commentFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        // 임시 저장소
        var crewComments = [CrewComment]()
        
        let postDataSuccess = PublishRelay<[CrewComment]>()
        let postDataFailure = PublishRelay<APIError>()
        let commentSuccess = PublishRelay<Int>()
        let commentFailure = PublishRelay<APIError>()
        
        input.postIdentifier
            .flatMap {
                
                return APIManager.callAPI(router: Router.fetchPost(postID: $0), dataModel: PostData.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let postData):
                    
                    crewComments = postData.comments
                    crewComments.sort { $0.createdAt < $1.createdAt }
                    
                    postDataSuccess.accept(crewComments)
                case .failure(let apiError):
                    
                    postDataFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        input.commentInputObservable
            .flatMap {
                
                let commentQuery = CommentQuery(content: $0)
             
                return APIManager.callAPI(router: Router.comment(postID: self.postIdentifier, query: commentQuery), dataModel: CrewComment.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let crewComment):
                    
                    crewComments.append(crewComment)
                    crewComments.sort { $0.createdAt < $1.createdAt }
                    
                    postDataSuccess.accept(crewComments)
                    commentSuccess.accept(crewComments.endIndex)
                    
                case .failure(let apiError):
                    commentFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
            
        
        return Output(postDataSuccess: postDataSuccess,
                      postDataFailure: postDataFailure,
                      commentSuccess: commentSuccess,
                      commentFailure: commentFailure)
    }
}
