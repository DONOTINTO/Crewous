//
//  WithoutCrewViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class WithoutCrewViewController: BaseViewController<WithoutCrewView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        layoutView.makeCrewButton.rx.tap
            .bind(with: self) { owner, _ in
                
                owner.layoutView.makeCrewButton.animate()
                
                var config = PHPickerConfiguration(photoLibrary: .shared())
                config.filter = PHPickerFilter.any(of: [.images])
                config.selectionLimit = 1
                config.selection = .default
                config.preferredAssetRepresentationMode = .current
                
                let phPicker = PHPickerViewController(configuration: config)
                phPicker.delegate = self
                owner.tabBarController?.tabBar.isHidden = true
                
                owner.navigationController?.pushViewController(phPicker, animated: true)
                
            }.disposed(by: disposeBag)
    }
}

extension WithoutCrewViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            self.tabBarController?.tabBar.isHidden = false
            picker.navigationController?.popViewController(animated: true)
            return
        }
        
        let result = results[0]
        
        let itemProvider = result.itemProvider
        
        itemProvider.loadObject(ofClass: UIImage.self) { readingImage, error in
            
            guard let image = readingImage as? UIImage,
                  let data = image.jpegData(compressionQuality: 1.0) else { return }
            
            DispatchQueue.main.sync {
                
                let nextVC = MakeCrewViewController()
                nextVC.viewModel.imageData = data
                
                let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                picker.navigationItem.backBarButtonItem = backButton
                picker.navigationItem.backBarButtonItem?.tintColor = .white
                picker.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
