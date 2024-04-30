//
//  MakeCrewView.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import SnapKit

final class MakeCrewView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let imageView = UIImageView()
    
    let crewNameLiteralLabel = UILabel()
    let crewNameTextField = UITextField()
    
    let timeLiteralLabel = UILabel()
    let timeTextField = UITextField()
    
    let placeLiteralLabel = UILabel()
    let placeTextField = UITextField()
    
    let membershipFeeLiteralLabel = UILabel()
    let membershipFeeTextField = UITextField()
    
    let uniformLiteralLabel = UILabel()
    let uniformTextField = UITextField()
    
    let introduceLiteralLabel = UILabel()
    let introduceTextView = UITextView()
    
    let bottomLayoutView = UIView()
    let createCrewButton = UIButton()
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [imageView, crewNameLiteralLabel, crewNameTextField, timeLiteralLabel, timeTextField, placeLiteralLabel, placeTextField, membershipFeeLiteralLabel, membershipFeeTextField, uniformLiteralLabel, uniformTextField, introduceLiteralLabel, introduceTextView, bottomLayoutView, createCrewButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        let ratio = (UIScreen.main.bounds.width / 5) * 2.5
        
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.horizontalEdges.equalTo(contentView)
            $0.height.equalTo(ratio)
        }
        
        crewNameLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        crewNameTextField.snp.makeConstraints {
            $0.top.equalTo(crewNameLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(50)
        }
        
        timeLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(crewNameTextField.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        timeTextField.snp.makeConstraints {
            $0.top.equalTo(timeLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(50)
        }
        
        placeLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(timeTextField.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(50)
        }
        
        membershipFeeLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        membershipFeeTextField.snp.makeConstraints {
            $0.top.equalTo(membershipFeeLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(50)
        }
        
        uniformLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(membershipFeeTextField.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        uniformTextField.snp.makeConstraints {
            $0.top.equalTo(uniformLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(50)
        }
        
        introduceLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(uniformTextField.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        introduceTextView.snp.makeConstraints {
            $0.top.equalTo(introduceLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(400)
            $0.bottom.equalTo(contentView).inset(150)
        }
        
        bottomLayoutView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        
        createCrewButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(bottomLayoutView).inset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        crewNameLiteralLabel.custom(title: "CREW NAME", color: .white, fontScale: .semiLight, fontSize: .tiny)
        crewNameTextField.custom(placeholder: "crew name", fontSize: .small)
        
        timeLiteralLabel.custom(title: "TIME", color: .white, fontScale: .semiLight, fontSize: .tiny)
        timeTextField.custom(placeholder: "ex) 매주 토요일 저녁 8시", fontSize: .small)
        
        placeLiteralLabel.custom(title: "PLACE", color: .white, fontScale: .semiLight, fontSize: .tiny)
        placeTextField.custom(placeholder: "ex) 00역 근처 체육관", fontSize: .small)
        
        membershipFeeLiteralLabel.custom(title: "MEMBERSHIP FEE (1YEAR)", color: .white, fontScale: .semiLight, fontSize: .tiny)
        membershipFeeTextField.custom(placeholder: "원", fontSize: .small)
        membershipFeeTextField.keyboardType = .numberPad
        
        uniformLiteralLabel.custom(title: "UNIFORM COLOR", color: .white, fontScale: .semiLight, fontSize: .tiny)
        uniformTextField.custom(placeholder: "ex) Black / White", fontSize: .small)
        
        introduceLiteralLabel.custom(title: "INTRODUCE", color: .white, fontScale: .semiLight, fontSize: .tiny)
        introduceTextView.textColor = .customGray
        introduceTextView.font = FontManager.getFont(scale: .semiBold, size: .small)
        introduceTextView.layer.cornerRadius = 10
        introduceTextView.layer.borderWidth = 0.5
        introduceTextView.layer.borderColor = UIColor.customGray.cgColor
        introduceTextView.backgroundColor = .white
        introduceTextView.text = "농구 크루원을 모집하는 내용을 상세히 작성해주세요.\n\n모집과 관련되지 않은 상업적인 내용은 삭제될 수 있습니다."
        
        bottomLayoutView.backgroundColor = .white
        createCrewButton.custom(title: "CREATE CREW", titleColor: .black, bgColor: .customGreen)
    }
    
    func configure(_ data: Data) {
        
        imageView.image = UIImage(data: data)
    }
}
