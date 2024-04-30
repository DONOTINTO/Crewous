//
//  ContentPageViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ContentPageViewModel {
    
    let postData = PublishRelay<PostData>()
    let userData = PublishRelay<[FetchUserDataModel]>()
    let selectedPage = PublishRelay<Int>()
    let afterPagingEvent = PublishRelay<String>()
}
