//
//  CrewContentViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class CrewContentViewModel {
 
    var postData = PublishRelay<PostData>()
    var userData = PublishRelay<[FetchUserDataModel]>()
    
    let category = BehaviorRelay(value: ["INFO", "MEMBERS"])
    var selected = 0
    
    let newSelected = BehaviorRelay(value: 0)
    let isNext = PublishRelay<Bool>()
    
    var disposeBag = DisposeBag()
    
    init() {
        
        newSelected
            .bind(with: self) { owner, newSelected in
                
                let isNext = (newSelected - owner.selected) > 0
                owner.selected = newSelected
                owner.isNext.accept(isNext)
                
            }.disposed(by: disposeBag)
    }
}
