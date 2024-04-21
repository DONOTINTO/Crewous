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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        viewModel.data
            .bind(with: self) { owner, data in
                
                owner.setViewControllers([owner.pages[0]], direction: .forward, animated: true)
                
                guard let infoVC = owner.pages[0] as? InfoPageViewController else { return }
                
                infoVC.viewModel.data.accept(data)
                
            }.disposed(by: disposeBag)
        
        let observable = Observable.combineLatest(viewModel.data, viewModel.afterPagingEvent)
        
        observable
            .bind(with: self) { owner, data in
                
                let (postData, identifier) = data
                
                guard let vc = owner.pages.filter({ $0.identifier == identifier }).first else { return }
                
                if let infoVC = vc as? InfoPageViewController {
                    infoVC.viewModel.data.accept(postData)
                }
                
                if let memberVC = vc as? MemberPageViewController {
                    memberVC.viewModel.data.accept(postData)
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
        guard let changedVC = pages.filter({ $0.identifier != vc.identifier }).first else { return }
        
        viewModel.afterPagingEvent.accept(changedVC.identifier)
    }
}