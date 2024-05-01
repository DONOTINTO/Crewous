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
    
    let viewModel = PayViewModel()
    
    var payDelegate: PayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        Observable.zip(viewModel.postTitleObservable, viewModel.amountObservable)
            .bind(with: self) { owner, data in
                
                let (title, amount) = data
                
                PaymentManager.paid(amount: amount, webView: owner.layoutView.wkWebView, postTitle: title) { response in
                    
                    guard let response,
                          let success = response.success else { return }
                    
                    if success {
                        print("⚠️⚠️ 결제 성공 ⚠️⚠️")
                        self.payDelegate?.payComplete(response: response)
                        self.dismiss(animated: true)
                    } else {
                        print("⚠️⚠️ 결제 취소 ⚠️⚠️")
                        self.dismiss(animated: true)
                    }
                }
            }.disposed(by: disposeBag)
    }
}
