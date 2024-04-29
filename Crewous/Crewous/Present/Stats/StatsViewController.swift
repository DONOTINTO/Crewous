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

        #if DEBUG
        
        // let a = PublishRelay<Void>()
        // a.flatMap {
        //     return APIManager.callAPI(router: Router.like2(postID: "66210e0e438b876b25f7a8b4", query: Like2Query(like_status: true)), dataModel: Like2DataModel.self)
        // }.subscribe(with: self) { owner, result in
        //     
        //     switch result {
        //         
        //     case .success(let success):
        //         print(success)
        //     case .failure(let failure):
        //         print(failure)
        //     }
        // }.disposed(by: disposeBag)
        // 
        // a.accept(())
        
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutView.indicator.startAnimating()
    }
    
    override func bind() {
        
        let profileChangeObservable = PublishRelay<Data>()
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto,
               let imageData = photo.image.compressedJPEGData {
                
                let alert = UIAlertController(title: "", message: "save the new profile Image", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "YES", style: .default) {_ in 
                    profileChangeObservable.accept(imageData)
                    picker.dismiss(animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "NO", style: .cancel)
                
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                
                picker.present(alert, animated: true)
            }
        }
        
        layoutView.testButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.present(owner.picker, animated: true)
            }.disposed(by: disposeBag)
        
        let viewWillAppearObservable = self.rx.viewWillAppear
        
        let input = StatsViewModel.Input(viewWillAppearObservable: viewWillAppearObservable, 
                                         profileChangeObservable: profileChangeObservable)
        let output = viewModel.transform(input: input)
        
        // 유저 정보 불러오기 성공
        
        Observable.zip(output.fetchSelfSuccess, output.fetchCrewSuccess)
            .bind(with: self) { owner, datas in
                
                owner.layoutView.indicator.stopAnimating()
                
                let (fetchSelfData, fetchCrewData) = datas
                
                let mappingData: [String] = fetchSelfData.nick.split(separator: "/").map { String($0) }
                let nick = mappingData[0]
                let height = mappingData[1]
                let weight = mappingData[2]
                let position = mappingData[3]
                
                owner.layoutView.nickLabel.text = nick
                owner.layoutView.heightInfoLabel.text = "\(height)CM"
                owner.layoutView.weightInfoLabel.text = "\(weight)KG"
                owner.layoutView.positionInfoLabel.text = position
                
                guard let crewData = fetchCrewData.data.first,
                      let crewName = crewData.crewName else { return }
                
                owner.layoutView.crewLabel.text = "Crew - \(crewName)"
                owner.layoutView.crewInfoLabel.text = crewName
                
            }.disposed(by: disposeBag)
        
        // 유저 정보 불러오기 실패
        output.fetchFailure.bind(with: self) { owner, apiError in
            
            owner.layoutView.indicator.stopAnimating()
            
            // 재호출
            owner.errorHandler(apiError, calltype: .fetchSelf)
        }.disposed(by: disposeBag)
        
        
        
        // 탈퇴(테스트)
        layoutView.withDrawButton.rx.tap
            .flatMap {
                
                return APIManager.callAPI(router: Router.withDraw, dataModel: WithDrawDataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let data):
                    
                    owner.makeAlert(msg: "탈퇴 완료") { [weak self] _ in
                        
                        guard let self else { return }
                        
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
