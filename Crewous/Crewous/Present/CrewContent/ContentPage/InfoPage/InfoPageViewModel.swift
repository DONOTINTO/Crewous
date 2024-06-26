//
//  InfoPageViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class InfoPageViewModel {
    
    var infoTitle = ["Date", "Place", "Membership Fee", "Uniform Color"]
    
    var info = PublishRelay<[String]>()
    var postData = PublishRelay<PostData>()
}
