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
    
    func forceQuit(_ errorCode: Int) {
        
        let alert = UIAlertController(title: "Error", message: "Quotes with unexpected error -\(errorCode)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Quit", style: .cancel) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
    func makeAlert(msg: String, handler: @escaping ((UIAlertAction) -> Void) = { _ in }) {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
}
