//
//  SettingViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SettingViewController: BaseViewController<SettingView> {
    
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        
        layoutView.tableView.estimatedRowHeight = UITableView.automaticDimension
        layoutView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        layoutView.tableView.register(SettingTableHeaderView.self, forHeaderFooterViewReuseIdentifier: SettingTableHeaderView.identifier)
    }
    
    override func bind() {
        
        // 테이블 뷰 delegate 설정
        layoutView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 셀 선택 분기처리
        layoutView.tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                
                let title = owner.viewModel.dataSource[indexPath.section].items[indexPath.row].title
                
                switch title {
                case .logout:
                    
                    UDManager.accessToken = ""
                    UDManager.refreshToken = ""
                    UDManager.isLogin = false
                    UDManager.userID = ""
                    
                    owner.changeRootViewToSignIn()
                case .withDraw:
                    
                    owner.viewModel.withDrawClicked.accept(())
                }
                
            }.disposed(by: disposeBag)
        
        // 회원 탈퇴 성공
        viewModel.withDrawSuccess
            .bind(with: self) { owner, _ in
                
                owner.makeAlert(msg: "탈퇴 완료") { _ in
                    
                    owner.changeRootViewToSignIn()
                }
            }.disposed(by: disposeBag)
        
        // 회원 탈퇴 실패
        viewModel.withDrawFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .withDraw)
                
            }.disposed(by: disposeBag)
        
        // 테이블 뷰 셀 설정
        viewModel.dataSource = RxTableViewSectionedReloadDataSource<SettingDataSection> { dataSource, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = item.title.title
            cell.selectionStyle = .none
            
            return cell
        }
        
        let settingDatas = [
            SettingDataSection(header: "Setting", items: [
                SettingDataSourceModel(title: .logout),
                SettingDataSourceModel(title: .withDraw)])
        ]
        
        viewModel.settingDatas.bind(to: layoutView.tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        viewModel.settingDatas.accept(settingDatas)
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingTableHeaderView.identifier) as? SettingTableHeaderView else { return UITableViewHeaderFooterView() }
        
        header.titleLabel.text = viewModel.dataSource[section].header
        
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
}
