//
//  BaseViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import RxSwift

class BaseViewController<LayoutView: UIView>: UIViewController {

    var layoutView: LayoutView {
        
        return view as! LayoutView
    }
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        
        self.view = LayoutView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        configure()
        makeBackBarButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.layoutView.endEditing(true)
    }
    
    func bind() { }

    func configure() { }
    
    func configureCollectionView() { }
    
    func configureNavigation() { }
    
    private func makeBackBarButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .white
    }
}
