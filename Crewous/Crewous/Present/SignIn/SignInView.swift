//
//  SignInView.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import SnapKit

class SignInView: BaseView {
    
    let emailTextField = UITextField()
    let emailValidLabel = UILabel()
    let passwordTextField = UITextField()
    let signInValidLabel = UILabel()
    let signInButton = UIButton()
    let createLabel = UILabel()

    override func configureHierarchy() {
        
        [emailTextField, emailValidLabel, passwordTextField, signInValidLabel, signInButton, createLabel].forEach { addSubview($0) }
    }

    override func configureLayout() {
        
        emailTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.snp.centerY)
            $0.height.equalTo(50)
        }
        
        emailValidLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailValidLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        signInValidLabel.snp.makeConstraints {
            $0.bottom.equalTo(signInButton.snp.top).offset(-5)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
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
        
        emailTextField.custom(placeholder: "User Email", imageStr: "person.fill")
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.custom(placeholder: "User Password", imageStr: "lock.fill")
        passwordTextField.isSecureTextEntry = true
        
        signInButton.custom(title: "Sign In", titleColor: .black, bgColor: .customGreen)
        signInButton.isEnabled = false
        
        createLabel.text = "Create Account"
        createLabel.textColor = .customGray
        createLabel.font = FontManager.getFont(scale: .bold, size: .small)
        createLabel.isUserInteractionEnabled = true
        
        signInValidLabel.text = "Please, Check Your Email & Password"
        signInValidLabel.textColor = .systemRed
        signInValidLabel.font = .systemFont(ofSize: 15, weight: .regular)
        signInValidLabel.isHidden = true
    }
}
