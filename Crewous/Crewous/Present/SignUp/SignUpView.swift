//
//  SignUpView.swift
//  Crewous
//
//  Created by 이중엽 on 4/12/24.
//

import UIKit
import SnapKit

class SignUpView: BaseView {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nickTextField = UITextField()
    let heightTextField = UITextField()
    let weightTextField = UITextField()
    let positionTextField = UITextField()
    let signUpButton = UIButton()
    
    override func configureHierarchy() {
        
        [emailTextField, passwordTextField, nickTextField, heightTextField, weightTextField, positionTextField, signUpButton].forEach { addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        let startPoint = UIScreen.main.bounds.height / 12
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(startPoint)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        nickTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(nickTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        positionTextField.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(positionTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
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
    }
}
