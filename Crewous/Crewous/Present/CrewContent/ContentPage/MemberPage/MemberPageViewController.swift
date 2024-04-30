//
//  MemberPageViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MemberPageViewController: BaseViewController<MemberPageView> {
    
    let viewModel = MemberPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        viewModel.userData
            .bind(to: layoutView.tableView.rx.items(cellIdentifier: MemberPageTableViewCell.identifier,
                                                    cellType: MemberPageTableViewCell.self)) { index, data, cell in
                
                let mappingData: [String] = data.nick.split(separator: "/").map { String($0) }
                let nick = mappingData[0]
                let position = mappingData[3]
                
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.configure(nick: nick, position: position)
                
                if let image = data.profileImage {
                    
                    cell.profileImageView.loadImage(from: image)
                }
                
            }.disposed(by: disposeBag)
    }
    
    override func configure() {
        layoutView.tableView.register(MemberPageTableViewCell.self, forCellReuseIdentifier: MemberPageTableViewCell.identifier)
    }
}
