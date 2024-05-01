//
//  PayViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class PayViewModel {
    
    let postTitleObservable = PublishRelay<String>()
    let amountObservable = PublishRelay<String>()
}
