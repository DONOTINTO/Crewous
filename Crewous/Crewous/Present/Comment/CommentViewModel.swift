//
//  CommentViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class CommentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var postIdentifier: String = ""
    
    struct Input {
        
        let postIdentifier: PublishRelay<String>
        let commentInputObservable: Observable<String>
        let itemDeleteObservable: PublishRelay<String>
    }
    
    struct Output {
     
        let postDataSuccess: PublishRelay<[CommentSection]>
        let postDataFailure: PublishRelay<APIError>
        
        let commentSuccess: PublishRelay<Int>
        let commentFailure: PublishRelay<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        // 임시 저장소
        var crewComments = [CrewComment]()
        
        let postDataSuccess = PublishRelay<[CommentSection]>()
        let postDataFailure = PublishRelay<APIError>()
        let commentSuccess = PublishRelay<Int>()
        let commentFailure = PublishRelay<APIError>()
        let commentDeleteFailure = PublishRelay<APIError>()
        
        input.postIdentifier
            .flatMap {
                
                return APIManager.callAPI(router: Router.fetchPost(postID: $0), dataModel: PostData.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let postData):
                    
                    crewComments = postData.comments
                    crewComments.sort { $0.createdAt < $1.createdAt }
                    
                    postDataSuccess.accept([CommentSection(items: crewComments)])
                    // postDataSuccess.accept(crewComments)
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
                    
                    postDataSuccess.accept([CommentSection(items: crewComments)])
                    commentSuccess.accept(crewComments.endIndex)
                    
                case .failure(let apiError):
                    commentFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
        
        // 댓글 삭제
        input.itemDeleteObservable
            .withUnretained(self)
            .flatMap { owner, commentID in
                
                return APIManager.callAPI(router: Router.commentDelete(postID: owner.postIdentifier, commentID: commentID))
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(_):
                    input.postIdentifier.accept(owner.postIdentifier)
                case .failure(let apiError):
                    commentDeleteFailure.accept(apiError)
                }
            }.disposed(by: disposeBag)
            
        
        return Output(postDataSuccess: postDataSuccess,
                      postDataFailure: postDataFailure,
                      commentSuccess: commentSuccess,
                      commentFailure: commentFailure)
    }
}

struct CommentSection {
    
    var items: [CrewComment]
}

extension CommentSection: SectionModelType {
    
    typealias Item = CrewComment
    
    init(original: CommentSection, items: [CrewComment]) {
        
        self = original
        self.items = items
    }
}
