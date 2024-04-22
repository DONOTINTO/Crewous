//
//  ContentPageViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class ContentPageViewController: UIPageViewController {
    
    let viewModel = ContentPageViewModel()
    var pages = [InfoPageViewController(), MemberPageViewController()]
    
    let disposeBag = DisposeBag()
    
    var pageDelegate: PageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        viewModel.postData
            .bind(with: self) { owner, data in
                
                owner.setViewControllers([owner.pages[0]], direction: .forward, animated: true)
                
                guard let infoVC = owner.pages[0] as? InfoPageViewController else { return }
                
                infoVC.viewModel.postData.accept(data)
                
            }.disposed(by: disposeBag)
        
        let observable = Observable.combineLatest(viewModel.postData, viewModel.userData, viewModel.afterPagingEvent)
        
        observable
            .bind(with: self) { owner, data in
                
                let (postData, userData, identifier) = data
                
                guard let vc = owner.pages.filter({ $0.id == identifier }).first else { return }
                
                if let infoVC = vc as? InfoPageViewController {
                    infoVC.viewModel.postData.accept(postData)
                    owner.pageDelegate?.previousComplete(0)
                }
                
                if let memberVC = vc as? MemberPageViewController {
                    memberVC.viewModel.userData.accept(userData)
                    owner.pageDelegate?.nextComplete(1)
                }
                
            }.disposed(by: disposeBag)
    }
}

extension ContentPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let vc = previousViewControllers[0]
        guard let changedVC = pages.filter({ $0.id != vc.id }).first else { return }
        
        viewModel.afterPagingEvent.accept(changedVC.id)
    }
}
