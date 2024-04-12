//
//  SignUpView.swift
//  Crewous
//
//  Created by 이중엽 on 4/12/24.
//

import UIKit
import SnapKit

class SignUpView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nickTextField = UITextField()
    let heightTextField = UITextField()
    let weightTextField = UITextField()
    let positionTextField = UITextField()
    let signUpButton = UIButton()
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [emailTextField, passwordTextField, nickTextField, heightTextField, weightTextField, positionTextField, signUpButton].forEach { contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        let startPoint = UIScreen.main.bounds.height / 12
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(startPoint)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        nickTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(nickTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        positionTextField.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(positionTextField.snp.bottom).offset(100)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView).inset(50)
        }
    }
    
    override func configureView() {
        
        emailTextField.custom(placeholder: "User Email", imageStr: "person.fill")
        passwordTextField.custom(placeholder: "Password", imageStr: "lock.fill")
        nickTextField.custom(placeholder: "Nickname", imageStr: "visionpro")
        heightTextField.custom(placeholder: "Height", imageStr: "figure.wave")
        weightTextField.custom(placeholder: "Weight", imageStr: "scalemass")
        positionTextField.custom(placeholder: "Postion", imageStr: "figure.basketball")
        signUpButton.custom(title: "Sign Up", titleColor: .black, bgColor: .customGreen)
        
        heightTextField.keyboardType = .decimalPad
        weightTextField.keyboardType = .decimalPad
    }
}
