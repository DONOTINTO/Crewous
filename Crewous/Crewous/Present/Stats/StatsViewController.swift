//
//  StatsViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import YPImagePicker

class StatsViewController: BaseViewController<StatsView> {
    
    let viewModel = StatsViewModel()
    let picker = YPImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutView.indicatorStatus(isStart: true)
    }
    
    override func bind() {
        
        // MARK: Gesture Event
        let profileChangeObservable = PublishRelay<Data>()
        
        let profileTapGesture = UITapGestureRecognizer()
        layoutView.profileViewAddTapGesture(profileTapGesture)
        
        // YP Image Picker 실행
        profileTapGesture.rx.event.bind(with: self) { owner, _ in
            
            owner.present(owner.picker, animated: true)
        }.disposed(by: disposeBag)
        
        // YP Image Picker 선택 / 종료
        picker.didFinishPicking { [unowned picker] items, _ in
            
            if let photo = items.singlePhoto,
               let imageData = photo.image.compressedJPEGData {
                
                let alert = UIAlertController(title: "", message: "save the new profile Image", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "YES", style: .default) { _ in
                    
                    profileChangeObservable.accept(imageData)
                    picker.dismiss(animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "NO", style: .cancel)
                
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                
                picker.present(alert, animated: true)
            } else {
                picker.dismiss(animated: true)
            }
        }
        
        // MARK: 유저
        let input = StatsViewModel.Input(viewWillAppearObservable: self.rx.viewWillAppear,
                                         profileChangeObservable: profileChangeObservable)
        let output = viewModel.transform(input: input)
        
        // 유저 정보 불러오기 성공
        Observable.zip(output.fetchSelfSuccess, output.fetchCrewSuccess)
            .bind(with: self) { owner, datas in
                
                let (fetchSelfData, fetchMyCrewData) = datas
                
                owner.layoutView.indicatorStatus(isStart: false)
                owner.layoutView.configure(fetchSelfData: fetchSelfData, fetchMyCrewData: fetchMyCrewData)
                
            }.disposed(by: disposeBag)
        
        // 유저 정보 불러오기 실패
        output.fetchFailure.bind(with: self) { owner, apiError in
            
            owner.layoutView.indicatorStatus(isStart: false)
            // 재호출
            owner.errorHandler(apiError, calltype: .fetchSelf)
        }.disposed(by: disposeBag)
        
        // 유저 프로필 업데이트
        output.updateProfileSuccess
            .bind(with: self) { owner, data in
                
                if let image = data.profileImage {
                    owner.layoutView.updateProfileImage(image: image)
                }
                
            }.disposed(by: disposeBag)
    }
}

extension StatsViewController {
    
    func testCode() {
        
        // 탈퇴(테스트)
        layoutView.withDrawButton.rx.tap
            .flatMap {
                
                return APIManager.callAPI(router: Router.withDraw, dataModel: WithDrawDataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(_):
                    
                    owner.makeAlert(msg: "탈퇴 완료") { _ in
                        
                        owner.changeRootViewToSignIn()
                    }
                    
                case .failure(_):
                    print("fail")
                }
            }.disposed(by: disposeBag)
        
        // 로그아웃(테스트용)
        layoutView.logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.changeRootViewToSignIn()
            }.disposed(by: disposeBag)
    }
}
