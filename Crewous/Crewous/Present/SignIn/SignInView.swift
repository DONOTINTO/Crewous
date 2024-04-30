//
//  SignInView.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import SnapKit

final class SignInView: BaseView {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signInButton = UIButton()
    
    private let emailValidLabel = UILabel()
    private let signInValidLabel = UILabel()
    private let createLabel = UILabel()
    private let indicator = UIActivityIndicatorView(style: .medium)

    override func configureHierarchy() {
        
        [emailTextField, emailValidLabel, passwordTextField, signInValidLabel, signInButton, createLabel, indicator].forEach { addSubview($0) }
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
        
        indicator.snp.makeConstraints {
            $0.bottom.equalTo(signInButton.snp.top).offset(-10)
            $0.trailing.equalTo(signInButton).inset(10)
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
        
        createLabel.custom(title: "Create Account", color: .customGray, fontScale: .bold, fontSize: .small)
        createLabel.isUserInteractionEnabled = true
        
        signInValidLabel.custom(title: "Please, Check Your Email & Password", color: .systemRed, fontSize: 15)
        signInValidLabel.isHidden = true
        
        indicator.hidesWhenStopped = true
        indicator.tintColor = .customBlack
        
        #if DEBUG
        
        emailTextField.text = "test@meme.com"
        passwordTextField.text = "a123123@"
        
        #endif
    }
    
    func addTapGesture(_ gesture: UITapGestureRecognizer) {
        
        self.createLabel.addGestureRecognizer(gesture)
    }
    
    func indicatorStatus(isStart: Bool) {
        
        indicator.isHidden = !isStart
        isStart ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func signInvalidLabelStatus(isHidden: Bool) {
        
        self.signInValidLabel.isHidden = isHidden
    }
}
