//
//  PaymentManager.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import Foundation
import iamport_ios
import WebKit

class PaymentManager {
    
    static func paid(amount: String, webView: WKWebView, postTitle: String, completionHandler: @escaping (IamportResponse?) -> Void) {
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: APIKey.pgKey.rawValue), // PG 사
            merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))", // 주문번호
            amount: amount).then { // 가격
                $0.pay_method = PayMethod.card.rawValue // 결제수단
                $0.name = postTitle // 주문명
                $0.buyer_name = "이중엽"
                $0.app_scheme = "goods99j" // 결제 후 앱으로 복귀 위한 app scheme
            }
        
        Iamport.shared.paymentWebView(webViewMode: webView,
                                      userCode: APIKey.userCode.rawValue,
                                      payment: payment,
                                      paymentResultCallback: completionHandler)
    }
}
