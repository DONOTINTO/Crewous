//
//  ContentPageViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class ContentPageViewModel {
    
    let postData = PublishRelay<PostData>()
    let userData = PublishRelay<[FetchUserDataModel]>()
    let afterPagingEvent = PublishRelay<String>()
}
