//
//  CrewContentViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit

class CrewContentViewController: BaseViewController<CrewContentView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        embeddedPageVC()
    }

    func embeddedPageVC() {
        
        let pageVC = ContentPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        self.addChild(pageVC)
        layoutView.containerView.addSubview(pageVC.view)
        
        pageVC.view.frame = layoutView.containerView.bounds
        pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageVC.didMove(toParent: self)
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
