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
    
    let data = PublishRelay<PostData>()
    let afterPagingEvent = PublishRelay<String>()
}
