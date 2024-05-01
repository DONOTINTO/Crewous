//
//  PayView.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import UIKit
import WebKit
import SnapKit

class PayView: BaseView {

    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func configureHierarchy() {
        
        addSubview(wkWebView)
    }
    
    override func configureLayout() {
        
        wkWebView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    override func configureView() {
        
    }
}
