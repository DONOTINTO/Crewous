//
//  SettingViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class SettingViewModel {
    
    var disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<SettingDataSection>!
    let settingDatas = PublishRelay<[SettingDataSection]>()
    
    let withDrawClicked = PublishRelay<Void>()
    let withDrawSuccess = PublishRelay<Void>()
    let withDrawFailure = PublishRelay<APIError>()
    
    init() {
        
        // 회원탈퇴
        withDrawClicked.flatMap {
            
            return APIManager.callAPI(router: Router.withDraw, dataModel: WithDrawDataModel.self)
        }.subscribe(with: self) { owner, result in
            
            switch result {
                
            case .success(_):
                
                owner.withDrawSuccess.accept(())
                
            case .failure(let apiError):
                
                owner.withDrawFailure.accept(apiError)
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: 섹션 데이터
struct SettingDataSection {
    var header: String
    var items: [SettingDataSourceModel]
}

extension SettingDataSection: SectionModelType {
    
    typealias Item = SettingDataSourceModel
    
    init(original: SettingDataSection, items: [SettingDataSourceModel]) {
        
        self = original
        self.items = items
    }
}

// MARK: 아이템 데이터
struct SettingDataSourceModel {
    var title: SettingType
}

extension SettingDataSourceModel: IdentifiableType, Equatable {
    
    var identity: String {
        return self.title.title
    }
}

enum SettingType: Int {
    
    case logout
    case withDraw
    
    var title: String {
        
        switch self {
        case .logout:
            return "Logout"
        case .withDraw:
            return "WithDraw"
        }
    }
}
