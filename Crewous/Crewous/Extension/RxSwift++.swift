//
//  RxSwift++.swift
//  Crewous
//
//  Created by 이중엽 on 4/14/24.
//

import UIKit
import RxSwift

extension RxSwift.Reactive where Base: UIViewController {
    public var viewWillAppear: Observable<Void> {
    return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map {
                let result: Void = $0.first as? Void ?? ()
                
                print(result)
                
                return result
            }
  }
}
