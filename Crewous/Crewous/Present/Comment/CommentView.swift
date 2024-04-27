//
//  CommentView.swift
//  Crewous
//
//  Created by 이중엽 on 4/27/24.
//

import UIKit
import SnapKit

class CommentView: BaseView {

    let titleLabel = UILabel()
    let lineView = UIView()
    let commentTableView = UITableView()
    let userInputTextField = UITextField()
    let inputButton = UIButton()
    
    override func configureHierarchy() {
        
        [titleLabel, lineView, commentTableView, userInputTextField, inputButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(10)
            $0.horizontalEdges.equalTo(self)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(0.5)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.horizontalEdges.equalTo(self)
            $0.bottom.equalTo(userInputTextField.snp.top)
        }
        
        userInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self).inset(20)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        
        inputButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(userInputTextField)
            $0.trailing.equalTo(userInputTextField).inset(10)
            $0.width.equalTo(inputButton.snp.height)
        }
    }
    
    override func configureView() {
        
        titleLabel.custom(title: "COMMNET", color: .customBlack, fontScale: .bold, fontSize: .medium)
        titleLabel.textAlignment = .center
        
        lineView.backgroundColor = .customGray.withAlphaComponent(0.3)
        
        commentTableView.backgroundColor = .clear
        
        userInputTextField.custom(placeholder: "Input Comment Here", fontSize: .small)
        
        let inputImage = UIImage(systemName: "arrow.up.circle")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        inputButton.setImage(inputImage, for: .normal)
    }

}
