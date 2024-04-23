//
//  InfoPageViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class InfoPageViewController: BaseViewController<InfoPageView> {
    
    let viewModel = InfoPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        
        viewModel.postData
            .bind(with: self) { owner, data in
                
                guard let time = data.timeInfo,
                      let place = data.placeInfo,
                      let membershipFee = data.membershipFee,
                      let uniformColor = data.uniformColor else { return }
                
                let info = [time, place, membershipFee, uniformColor]
                owner.viewModel.info.accept(info)
            }.disposed(by: disposeBag)
        
        viewModel.info
            .bind(to: layoutView.tableView.rx.items(cellIdentifier: InfoPageTableViewCell.identifier,
                                                    cellType: InfoPageTableViewCell.self)) { [weak self] index, data, cell in
                
                guard let self else { return }
                
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.configure(title: self.viewModel.infoTitle[index], content: data)
                
            }.disposed(by: disposeBag)
    }
    
    override func configure() {
        
        layoutView.tableView.register(InfoPageTableViewCell.self, forCellReuseIdentifier: InfoPageTableViewCell.identifier)
    }
}
