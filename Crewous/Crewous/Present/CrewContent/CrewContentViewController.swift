//
//  CrewContentViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class CrewContentViewController: BaseViewController<CrewContentView> {
    
    let viewModel = CrewContentViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        viewModel.data
            .bind(with: self) { owner, data in
                
                let pageVC = ContentPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                
                self.addChild(pageVC)
                owner.layoutView.containerView.addSubview(pageVC.view)
                
                pageVC.view.frame = owner.layoutView.containerView.bounds
                pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                pageVC.viewModel.data.accept(data)
                
                pageVC.didMove(toParent: self)
            }.disposed(by: disposeBag)
    }
    
    override func configureCollectionView() {
        
        layoutView.contentCollectionView.isScrollEnabled = false
        layoutView.contentCollectionView.delegate = self
        layoutView.contentCollectionView.dataSource = self
        layoutView.contentCollectionView.register(CrewContentCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension CrewContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CrewContentCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .brown
        
        return cell
    }
    
    
}
