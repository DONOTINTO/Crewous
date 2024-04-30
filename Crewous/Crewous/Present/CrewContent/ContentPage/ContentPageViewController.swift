//
//  ContentPageViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ContentPageViewController: UIPageViewController {
    
    let viewModel = ContentPageViewModel()
    var pages = [InfoPageViewController(), MemberPageViewController()]
    
    let disposeBag = DisposeBag()
    
    var pageDelegate: PageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        // post Data, user Data 넘겨받았을 때
        Observable.zip(viewModel.postData, viewModel.userData)
            .bind(with: self) { owner, data in
                
                let (postData, userData) = data
                
                owner.setViewControllers([owner.pages[0]], direction: .forward, animated: true)
                
                guard let infoVC = owner.pages[0] as? InfoPageViewController else { return }
                
                infoVC.viewModel.postData.accept(postData)
                
            }.disposed(by: disposeBag)
        
        // CrewContent에서 cell을 클릭하여 페이지 변경하였을 때 -> 셀에서 이미 변경된 정보를 알기 때문에 Delegate로 변경된 정보 전달할 필요 없음
        Observable.combineLatest(viewModel.postData, viewModel.userData, viewModel.selectedPage)
            .bind(with: self) { owner, data in
                
                let (postData, userData, seleted) = data
                
                let vc = owner.pages[seleted]
                
                if let infoVC = vc as? InfoPageViewController {
                    infoVC.viewModel.postData.accept(postData)
                }
                
                if let memberVC = vc as? MemberPageViewController {
                    memberVC.viewModel.userData.accept(userData)
                }
            }.disposed(by: disposeBag)
        
        // PageVC에서 스와이프로 페이지 변경했을 때 -> Delegate로 변경된 정보 전달해야함
        Observable.combineLatest(viewModel.postData, viewModel.userData, viewModel.afterPagingEvent)
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
