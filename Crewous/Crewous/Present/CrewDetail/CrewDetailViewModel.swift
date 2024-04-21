//
//  CrewDetailViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import Foundation
import RxSwift
import RxCocoa

class CrewDetailViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var data = PublishRelay<PostData>()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
