//
//  SignInView.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import SnapKit

class SignInView: BaseView {
    
    let userTextField = UITextField()
    let passwordTextField = UITextField()
    let signInButton = UIButton()
    let createLabel = UILabel()

    override func configureHierarchy() {
        
        [userTextField, passwordTextField, signInButton, createLabel].forEach { addSubview($0) }
    }

    override func configureLayout() {
        
        userTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.snp.centerY)
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(userTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(passwordTextField.snp.bottom).offset(50)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        createLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(signInButton.snp.bottom).offset(100)
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    
    override func configureView() {
        
        userTextField.custom(placeholder: "User Email", imageStr: "person.fill")
        userTextField.keyboardType = .emailAddress
        
        passwordTextField.custom(placeholder: "User Eamil", imageStr: "lock.fill")
        
        signInButton.custom(title: "Sign In", titleColor: .black, bgColor: .customGreen)
        
        createLabel.text = "Create Account"
        createLabel.textColor = .customGray
        createLabel.font = FontManager.getFont(scale: .bold, size: .small)
        createLabel.isUserInteractionEnabled = true
    }
}
