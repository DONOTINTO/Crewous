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
 
    let category: [String] = ["INFO", "MEMBERS"]
    
    var data = PublishRelay<PostData>()

    var selected = 0
    let newSelected = BehaviorRelay(value: 0)
    let isNext = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    
    
    init() {
        
        newSelected
            .bind(with: self) { owner, newSelected in
                
                let isNext = (newSelected - owner.selected) > 0
                owner.selected = newSelected
                owner.isNext.accept(isNext)
                
            }.disposed(by: disposeBag)
    }
}
