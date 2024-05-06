//
//  PayViewController.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa

class PayViewController: BaseViewController<PayView> {
    
    var viewModel: PaymentGatewayViewModel
    var payDelegate: PayDelegate
    
    init(viewModel: PaymentGatewayViewModel, payDelegate: PayDelegate) {
        self.viewModel = viewModel
        self.payDelegate = payDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.connectPG(webView: layoutView.wkWebView, payDelegate: payDelegate)
    }
    
    override func bind() {
        
        viewModel.paidSuccess
            .bind(with: self) { owner, _ in
                
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.paidCancel
            .bind(with: self) { owner, _ in
                
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
