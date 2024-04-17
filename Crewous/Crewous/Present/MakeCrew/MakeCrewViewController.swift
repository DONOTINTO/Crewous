//
//  MakeCrewViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

class MakeCrewViewController: BaseViewController<MakeCrewView> {
    
    let viewModel = MakeCrewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func bind() {
        
        // MARK: Tap Gesture
        let tapGesture = UITapGestureRecognizer()
        layoutView.scrollView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.subscribe(with: self) { owner, _ in
            
            owner.layoutView.scrollView.endEditing(true)
        }.disposed(by: disposeBag)
        
        // MARK: View Model
        
        let crewName = layoutView.crewNameTextField.rx.text.orEmpty.asObservable()
        let introduce = layoutView.introduceTextView.rx.text.orEmpty.asObservable()
        let time = layoutView.timeTextField.rx.text.orEmpty.asObservable()
        let place = layoutView.placeTextField.rx.text.orEmpty.asObservable()
        let membershipFee = layoutView.membershipFeeTextField.rx.text.orEmpty.asObservable()
        let uniform = layoutView.uniformTextField.rx.text.orEmpty.asObservable()
        
        let allData = Observable.combineLatest(crewName, introduce, time, place, membershipFee, uniform)
        
        let input = MakeCrewViewModel.Input(createButtonObservable: layoutView.createCrewButton.rx.tap.asObservable(), inputDataObservable: allData)
        let output = viewModel.transform(input: input)
        
        output.makeCrewSuccess
            .bind(with: self) { owner, postData in
                owner.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
        
        output.uploadImageFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .uploadImage) {
                    // API 토큰 재발급 -> 크루 생성 재시도
                    owner.layoutView.createCrewButton.sendActions(for: .touchUpInside)
                }
            }.disposed(by: disposeBag)
        
        output.makeCrewFailure
            .bind(with: self) { owner, apiError in
                
                owner.errorHandler(apiError, calltype: .makeCrew) {
                    // 크루 생성(포스트 게시) 실패, API 토큰 재발급 -> 크루 생성 재시도
                    owner.layoutView.createCrewButton.sendActions(for: .touchUpInside)
                }
            }.disposed(by: disposeBag)
    }
    
    override func configure() {
        
        layoutView.configure(viewModel.imageData)
        layoutView.crewNameTextField.delegate = self
        layoutView.timeTextField.delegate = self
        layoutView.placeTextField.delegate = self
        layoutView.membershipFeeTextField.delegate = self
        layoutView.uniformTextField.delegate = self
        layoutView.introduceTextView.delegate = self
    }
}

extension MakeCrewViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.customGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.customGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.resignFirstResponder()
        
        return true
    }
}

extension MakeCrewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "농구 크루원을 모집하는 내용을 상세히 작성해주세요.\n\n모집과 관련되지 않은 상업적인 내용은 삭제될 수 있습니다." {
            textView.text = ""
            textView.textColor = .white
        }
        
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "농구 크루원을 모집하는 내용을 상세히 작성해주세요.\n\n모집과 관련되지 않은 상업적인 내용은 삭제될 수 있습니다."
            textView.textColor = .customGray
        } else {
            textView.textColor = .white
        }
        
        textView.layer.borderColor = UIColor.customGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.resignFirstResponder()
    }
}
