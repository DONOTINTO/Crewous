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
    let emailValidLabel = UILabel()
    
    let passwordTextField = UITextField()
    let passwordValidLabel = UILabel()
    
    let nickTextField = UITextField()
    let nickValidLabel = UILabel()
    
    let heightTextField = UITextField()
    let heightValidLabel = UILabel()
    
    let weightTextField = UITextField()
    let weightValidLabel = UILabel()
    
    let positionTextField = UITextField()
    let positionValidLabel = UILabel()
    
    let signUpButton = UIButton()
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [emailTextField, emailValidLabel ,passwordTextField, passwordValidLabel, nickTextField, nickValidLabel, heightTextField, heightValidLabel, weightTextField, weightValidLabel, positionTextField, positionValidLabel, signUpButton].forEach { contentView.addSubview($0)
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
        
        emailValidLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        nickTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        nickValidLabel.snp.makeConstraints {
            $0.top.equalTo(nickTextField.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(nickTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        heightValidLabel.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        weightValidLabel.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        positionTextField.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }
        
        positionValidLabel.snp.makeConstraints {
            $0.top.equalTo(positionTextField.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(20)
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
        
        passwordTextField.isSecureTextEntry = true
        heightTextField.keyboardType = .decimalPad
        weightTextField.keyboardType = .decimalPad
        signUpButton.isEnabled = false
        
        emailValidLabel.text = "Incorrect email address."
        emailValidLabel.textColor = .customGray
        emailValidLabel.font = .systemFont(ofSize: 13)
        emailValidLabel.adjustsFontSizeToFitWidth = true
        emailValidLabel.isHidden = true
        
        passwordValidLabel.text = "8 to 20 (include: english, num, special char)"
        passwordValidLabel.textColor = .customGray
        passwordValidLabel.font = .systemFont(ofSize: 13)
        passwordValidLabel.adjustsFontSizeToFitWidth = true
        passwordValidLabel.isHidden = true
        
        nickValidLabel.text = "2 to 16"
        nickValidLabel.textColor = .customGray
        nickValidLabel.font = .systemFont(ofSize: 13)
        nickValidLabel.adjustsFontSizeToFitWidth = true
        nickValidLabel.isHidden = true
        
        heightValidLabel.text = "Only Number"
        heightValidLabel.textColor = .customGray
        heightValidLabel.font = .systemFont(ofSize: 13)
        heightValidLabel.adjustsFontSizeToFitWidth = true
        heightValidLabel.isHidden = true
        
        weightValidLabel.text = "Only Number"
        weightValidLabel.textColor = .customGray
        weightValidLabel.font = .systemFont(ofSize: 13)
        weightValidLabel.adjustsFontSizeToFitWidth = true
        weightValidLabel.isHidden = true
        
        positionValidLabel.text = "2 to 16"
        positionValidLabel.textColor = .customGray
        positionValidLabel.font = .systemFont(ofSize: 13)
        positionValidLabel.adjustsFontSizeToFitWidth = true
        positionValidLabel.isHidden = true
    }
}
