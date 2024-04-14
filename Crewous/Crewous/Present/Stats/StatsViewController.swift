//
//  StatsViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

class StatsViewController: BaseViewController<StatsView> {
    
    let viewModel = StatsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        super.bind()
        
        let viewWillAppearObservable = self.rx.viewWillAppear
        
        let input = StatsViewModel.Input(viewWillAppearObservable: viewWillAppearObservable)
        let output = viewModel.transform(input: input)
        
        // 유저 정보 불러오기 성공
        output.fetchSuccess.bind(with: self) { owner, fetchSelfData in
            
            let mappingData: [String] = fetchSelfData.nick.split(separator: "/").map { String($0) }
            let nick = mappingData[0]
            let height = mappingData[1]
            let weight = mappingData[2]
            let position = mappingData[3]
            
            owner.layoutView.nickLabel.text = nick
            owner.layoutView.heightInfoLabel.text = "\(height)CM"
            owner.layoutView.weightInfoLabel.text = "\(weight)KG"
            owner.layoutView.positionInfoLabel.text = position
            
        }.disposed(by: disposeBag)
        
        // 유저 정보 불러오기 실패
        output.fetchFailure.bind(with: self) { owner, apiError in
            
            owner.errorHandler(apiError, calltype: .fetchSelf)
            
        }.disposed(by: disposeBag)
    }
}
