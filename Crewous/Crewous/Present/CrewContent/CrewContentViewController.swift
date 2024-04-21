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
        
        // Page VC Embedded
        viewModel.data
            .bind(with: self) { owner, data in
                
                let pageVC = ContentPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                
                self.addChild(pageVC)
                owner.layoutView.containerView.addSubview(pageVC.view)
                
                pageVC.view.frame = owner.layoutView.containerView.bounds
                pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                // Post Data 전달
                pageVC.viewModel.data.accept(data)
                
                // 페이지 Delegate 설정
                pageVC.pageDelegate = self
                
                pageVC.didMove(toParent: self)
            }.disposed(by: disposeBag)
        
        // Collection View
        viewModel.category
            .bind(to: layoutView.contentCollectionView.rx.items(cellIdentifier: "cell",
                                                                cellType: CrewContentCollectionViewCell.self)) { [weak self] index, data, cell in
                
                guard let self else { return }
                cell.titleLabel.text = data
                
                cell.configure(isSelected: index == self.viewModel.selected)
                
            }.disposed(by: disposeBag)
        
        // Cell 클릭
        layoutView.contentCollectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                
                owner.viewModel.newSelected.accept(indexPath.row)
            }.disposed(by: disposeBag)
        
        // Selected 변경 시
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
