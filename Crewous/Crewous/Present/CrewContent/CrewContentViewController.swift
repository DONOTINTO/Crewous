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
                pageVC.pageDelegate = self
                
                pageVC.didMove(toParent: self)
            }.disposed(by: disposeBag)
        
        viewModel.isNext
            .bind(with: self) { owner, isNext in
                
                guard let vc = self.children.first, let pageVC = vc as? ContentPageViewController  else {return }
                let selected = owner.viewModel.selected
                
                let selectedVC = pageVC.pages[selected]
                
                pageVC.setViewControllers([selectedVC],
                                          direction: isNext ? .forward : .reverse,
                                          animated: true)
                
                owner.layoutView.contentCollectionView.reloadData()
                
            }.disposed(by: disposeBag)
    }
    
    override func configureCollectionView() {
        
        layoutView.contentCollectionView.isScrollEnabled = false
        layoutView.contentCollectionView.delegate = self
        layoutView.contentCollectionView.dataSource = self
        layoutView.contentCollectionView.register(CrewContentCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension CrewContentViewController: PageDelegate {
    
    func nextComplete(_ index: Int) {
        
        viewModel.newSelected.accept(index)
    }
    
    func previousComplete(_ index: Int) {
        
        viewModel.newSelected.accept(index)
    }
}

extension CrewContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CrewContentCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.category[indexPath.row]
        cell.titleLabel.text = data
        
        cell.configure(isSelected: indexPath.row == viewModel.selected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.newSelected.accept(indexPath.row)
    }
}
