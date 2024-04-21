//
//  InfoPageViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class InfoPageViewModel {
    
    var infoTitle = ["Date", "Place", "Uniform Color", "Membership Fee"]
    
    var info = PublishRelay<[String]>()
    var data = PublishRelay<PostData>()
}
