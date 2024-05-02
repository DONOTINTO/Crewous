//
//  StatsViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import YPImagePicker

final class StatsViewController: BaseViewController<StatsView> {
    
    let viewModel = StatsViewModel()
    
    private let picker = YPImagePicker()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HotCrewSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        Observable.zip(output.fetchSelfSuccess, output.fetchMyCrewSuccess)
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
        
        output.fetchCrewSuccess
            .bind(to: layoutView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func configureCollectionView() {
        
        layoutView.collectionView.register(HotCrewCollectionViewCell.self, forCellWithReuseIdentifier: HotCrewCollectionViewCell.identifier)
        layoutView.collectionView.register(HotCrewCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HotCrewCollectionReusableView.identifier)
        
        dataSource = RxCollectionViewSectionedReloadDataSource<HotCrewSection> { dataSource, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotCrewCollectionViewCell.identifier, for: indexPath) as? HotCrewCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(item)
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            
            if kind == UICollectionView.elementKindSectionHeader {
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HotCrewCollectionReusableView.identifier, for: indexPath) as? HotCrewCollectionReusableView else { return UICollectionReusableView() }
                
                header.configure("WEEKLY HOT CREW")
                
                return header
            } else {
                
                fatalError()
            }
        }
    }
}
