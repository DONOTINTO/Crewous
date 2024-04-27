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
            $0.leading.equalTo(self).inset(20)
            $0.bottom.greaterThanOrEqualTo(keyboardLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        
        inputButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.leading.equalTo(userInputTextField.snp.trailing)
            $0.trailing.equalTo(self).inset(10)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
    }
    
    override func configureView() {
        
        titleLabel.custom(title: "COMMNET", color: .customBlack, fontScale: .bold, fontSize: .medium)
        titleLabel.textAlignment = .center
        
        lineView.backgroundColor = .customGray.withAlphaComponent(0.3)
        
        commentTableView.backgroundColor = .clear
        
        userInputTextField.custom(placeholder: "Input Comment Here", fontSize: .small)
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        
        let inputImage = UIImage(systemName: "paperplane")?.withTintColor(.customGreen, renderingMode: .alwaysOriginal).withConfiguration(imageConfiguration)
        inputButton.setImage(inputImage, for: .normal)
    }

}
