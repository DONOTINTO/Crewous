//
//  PayViewModel.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa
import WebKit

protocol PaymentGatewayViewModel {
    
    var disposeBag: DisposeBag { get }
    
    var postTitle: String { get }
    var amount: String { get }
    var paymentService: PaymentService { get }
    
    var paidSuccess: PublishRelay<Void> { get }
    var paidCancel: PublishRelay<Void> { get }
    
    func connectPG(webView: WKWebView, payDelegate: PayDelegate)
}

class PayViewModel: PaymentGatewayViewModel {
    
    private(set) var disposeBag = DisposeBag()
    
    private(set) var postTitle: String
    private(set) var amount: String
    private(set) var paymentService: PaymentService
    
    let paidSuccess = PublishRelay<Void>()
    let paidCancel = PublishRelay<Void>()
    
    init(postTitle: String, amount: String, paymentService: PaymentService) {
        self.postTitle = postTitle
        self.amount = amount
        self.paymentService = paymentService
    }
    
    func connectPG(webView: WKWebView, payDelegate: any PayDelegate) {
        
        Observable.just((postTitle, amount))
            .subscribe(with: self) { owner, data in
                
                let (title, amount) = data
                
                owner.paymentService.paid(amount: amount, webView: webView, postTitle: title) { response in
                    
                    guard let response,
                          let success = response.success else { return }
                    
                    if success {
                        print("⚠️⚠️ 결제 성공 ⚠️⚠️")
                        payDelegate.payComplete(response: response)
                        owner.paidSuccess.accept(())
                    } else {
                        print("⚠️⚠️ 결제 취소 ⚠️⚠️")
                        owner.paidCancel.accept(())
                    }
                }
                
            }.disposed(by: disposeBag)
    }
}
